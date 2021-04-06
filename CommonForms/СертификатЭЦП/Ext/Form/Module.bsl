﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	СтруктураСертификата = Параметры.СтруктураСертификата;
	Отпечаток = Параметры.Отпечаток;
	
	Если Параметры.Свойство("АдресСертификата") Тогда
		АдресСертификата = Параметры.АдресСертификата;
	КонецЕсли;	
	
	КомуВыдан = СтруктураСертификата.КомуВыдан;
	КемВыдан = СтруктураСертификата.КемВыдан;
	ДействителенДо = СтруктураСертификата.ДействителенДо;
	Назначение = СтруктураСертификата.Назначение;
	
	НовоеНазначение = "";
	ДобавлятьКодНазначения = Истина;
	ЭлектроннаяЦифроваяПодпись.ЗаполнитьНазначениеСертификата(Назначение, НовоеНазначение, ДобавлятьКодНазначения);
	Назначение = НовоеНазначение;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура Выгрузить(Команда)
	
	Если НЕ ПодключитьРасширениеРаботыСФайлами() Тогда
		Возврат;
	КонецЕсли;
	
	Сертификат = ПолучитьСертификат(Неопределено);
	Если Сертификат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
	ДиалогОткрытияФайла.Заголовок = НСтр("ru = 'Выберите файл для сохранения сертификата'");
	ДиалогОткрытияФайла.Фильтр    = НСтр("ru = 'Файлы сертификатов (*.cer)|*.cer|Все файлы (*.*)|*.*'");
	ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
	Если НЕ ДиалогОткрытияФайла.Выбрать() Тогда
		Возврат;
	КонецЕсли;
	
	Сертификат.Выгрузить(ДиалогОткрытияФайла.ПолноеИмяФайла);
	
	Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Сертификат ЭЦП сохранен в файл ""%1""'"),
		ДиалогОткрытияФайла.ПолноеИмяФайла);
	
	Состояние(Текст);
	
КонецПроцедуры

&НаКлиенте
Процедура Проверить(Команда)
	
	МенеджерКриптографии = Неопределено;
	Сертификат = ПолучитьСертификат(МенеджерКриптографии);
	Если Сертификат = Неопределено ИЛИ МенеджерКриптографии = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Попытка
		МассивРежимовПроверки = Новый Массив;
		МассивРежимовПроверки.Добавить(РежимПроверкиСертификатаКриптографии.ИгнорироватьВремяДействия);
		МассивРежимовПроверки.Добавить(РежимПроверкиСертификатаКриптографии.РазрешитьТестовыеСертификаты);
		МенеджерКриптографии.ПроверитьСертификат(Сертификат, МассивРежимовПроверки);
		Предупреждение(НСтр("ru = 'Сертификат действителен'"));
	Исключение
		Текст = НСтр("ru = 'Сертификат недействителен.'") + Символы.ПС + КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		Предупреждение(Текст);
	КонецПопытки;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Функция ПолучитьСертификат(МенеджерКриптографии)
	
	ДвоичныеДанныеОтпечатка = Base64Значение(Отпечаток);
	МенеджерКриптографии = ЭлектроннаяЦифроваяПодписьКлиент.ПолучитьМенеджерКриптографии();
	
	Если ЗначениеЗаполнено(АдресСертификата) И ЭтоАдресВременногоХранилища(АдресСертификата) Тогда
		ДвоичныеДанныеСертификата = ПолучитьИзВременногоХранилища(АдресСертификата);
		Сертификат = Новый СертификатКриптографии(ДвоичныеДанныеСертификата);
	Иначе
		Если МенеджерКриптографии = Неопределено Тогда
			Возврат Неопределено;
		КонецЕсли;
		ХранилищеСертификатов = МенеджерКриптографии.ПолучитьХранилищеСертификатов();
		Сертификат = ХранилищеСертификатов.НайтиПоОтпечатку(ДвоичныеДанныеОтпечатка);
	КонецЕсли;
	
	Если Сертификат = Неопределено Тогда
		Предупреждение(НСтр("ru = 'Сертификат не найден'"));
	КонецЕсли;
	
	Возврат Сертификат;
	
КонецФункции

