﻿&НаКлиенте
Перем ОбновитьИнтерфейс;

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// Значения реквизитов формы
	РежимРаботы = ОбщегоНазначенияПовтИсп.РежимРаботыПрограммы();
	РежимРаботы = Новый ФиксированнаяСтруктура(РежимРаботы);
	
	// СтандартныеПодсистемы.ФайловыеФункции
	МаксимальныйРазмерФайла              = ФайловыеФункции.МаксимальныйРазмерФайлаОбщий() / (1024*1024);
	МаксимальныйРазмерФайлаОбластиДанных = ФайловыеФункции.МаксимальныйРазмерФайла() / (1024*1024);
	Если РежимРаботы.МодельСервиса Тогда
		Элементы.МаксимальныйРазмерФайла.МаксимальноеЗначение = МаксимальныйРазмерФайла;
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ФайловыеФункции
	
	// Настройки видимости при запуске
	
	// СтандартныеПодсистемы.ФайловыеФункции
	Элементы.ГруппаХранитьФайлыВТомахНаДиске.Видимость     = РежимРаботы.ЭтоАдминистраторСистемы;
	Элементы.ГруппаСправочникТомаХраненияФайлов.Видимость  = РежимРаботы.ЭтоАдминистраторСистемы;
	Элементы.ОбщиеПараметрыДляВсехОбластейДанных.Видимость = РежимРаботы.МодельСервиса И РежимРаботы.ЭтоАдминистраторСистемы;
	// Конец СтандартныеПодсистемы.ФайловыеФункции
	
	// Обновление состояния элементов
	УстановитьДоступность();
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	ОбновитьИнтерфейсПрограммы();
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

// СтандартныеПодсистемы.ФайловыеФункции
&НаКлиенте
Процедура ХранитьФайлыВТомахНаДискеПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ЗапрещатьЗагрузкуФайловПоРасширениюПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура СписокЗапрещенныхРасширенийОбластиДанныхПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура МаксимальныйРазмерФайлаОбластиДанныхПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура СписокРасширенийФайловOpenDocumentОбластиДанныхПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура СписокРасширенийТекстовыхФайловПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ФайловыеФункции

// СтандартныеПодсистемы.ЭлектроннаяЦифроваяПодпись
&НаКлиенте
Процедура ИспользоватьЭлектронныеЦифровыеПодписиПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ЭлектроннаяЦифроваяПодпись

////////////////////////////////////////////////////////////////////////////////
// Общие параметры для всех областей данных

// СтандартныеПодсистемы.ФайловыеФункции
&НаКлиенте
Процедура МаксимальныйРазмерФайлаПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура СписокЗапрещенныхРасширенийПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура СписокРасширенийФайловOpenDocumentПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ФайловыеФункции

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

// СтандартныеПодсистемы.ФайловыеФункции
&НаКлиенте
Процедура СправочникТомаХраненияФайлов(Команда)
	ОткрытьФорму("Справочник.ТомаХраненияФайлов.ФормаСписка", , ЭтаФорма);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ФайловыеФункции

// СтандартныеПодсистемы.ЭлектроннаяЦифроваяПодпись
&НаКлиенте
Процедура ОбщаяФормаНастройкиЭЦП(Команда)
	ОткрытьФорму("ОбщаяФорма.НастройкиЭЦП", , ЭтаФорма);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ЭлектроннаяЦифроваяПодпись

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// Клиент

&НаКлиенте
Процедура Подключаемый_ПриИзмененииРеквизита(Элемент, ОбновлятьИнтерфейс = Истина)
	
	Результат = ПриИзмененииРеквизитаСервер(Элемент.Имя);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Если ОбновлятьИнтерфейс Тогда
		#Если НЕ ВебКлиент Тогда
		ПодключитьОбработчикОжидания("ОбновитьИнтерфейсПрограммы", 1, Истина);
		ОбновитьИнтерфейс = Истина;
		#КонецЕсли
	КонецЕсли;
	
	СтандартныеПодсистемыКлиент.ПоказатьРезультатВыполнения(ЭтаФорма, Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнтерфейсПрограммы()
	
	#Если НЕ ВебКлиент Тогда
	Если ОбновитьИнтерфейс = Истина Тогда
		ОбновитьИнтерфейс = Ложь;
		ОбновитьИнтерфейс();
	КонецЕсли;
	#КонецЕсли
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Вызов сервера

&НаСервере
Функция ПриИзмененииРеквизитаСервер(ИмяЭлемента)
	
	Результат = Новый Структура;
	
	РеквизитПутьКДанным = Элементы[ИмяЭлемента].ПутьКДанным;
	
	СохранитьЗначениеРеквизита(РеквизитПутьКДанным, Результат);
	
	УстановитьДоступность(РеквизитПутьКДанным);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Возврат Результат;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Сервер

&НаСервере
Процедура СохранитьЗначениеРеквизита(РеквизитПутьКДанным, Результат)
	
	// Сохранение значений реквизитов, не связанных с константами напрямую (в отношении один-к-одному).
	Если РеквизитПутьКДанным = "" Тогда
		Возврат;
	КонецЕсли;
	
	// Определение имени константы.
	КонстантаИмя = "";
	Если НРег(Лев(РеквизитПутьКДанным, 14)) = НРег("НаборКонстант.") Тогда
		// Если путь к данным реквизита указан через "НаборКонстант".
		КонстантаИмя = Сред(РеквизитПутьКДанным, 15);
	Иначе
		// Определение имени и запись значения реквизита в соответствующей константе из "НаборКонстант".
		// Используется для тех реквизитов формы, которые связаны с константами напрямую (в отношении один-к-одному).
		
		// СтандартныеПодсистемы.ФайловыеФункции
		Если РеквизитПутьКДанным = "МаксимальныйРазмерФайла" Тогда
			НаборКонстант.МаксимальныйРазмерФайла = МаксимальныйРазмерФайла * (1024*1024);
			КонстантаИмя = "МаксимальныйРазмерФайла";
		ИначеЕсли РеквизитПутьКДанным = "МаксимальныйРазмерФайлаОбластиДанных" Тогда
			Если РежимРаботы.Локальный Или РежимРаботы.Автономный Тогда
				НаборКонстант.МаксимальныйРазмерФайла = МаксимальныйРазмерФайлаОбластиДанных * (1024*1024);
				КонстантаИмя = "МаксимальныйРазмерФайла";
			Иначе
				НаборКонстант.МаксимальныйРазмерФайлаОбластиДанных = МаксимальныйРазмерФайлаОбластиДанных * (1024*1024);
				КонстантаИмя = "МаксимальныйРазмерФайлаОбластиДанных";
			КонецЕсли;
		КонецЕсли;
		// Конец СтандартныеПодсистемы.ФайловыеФункции
		
	КонецЕсли;
	
	// Сохранения значения константы.
	Если КонстантаИмя <> "" Тогда
		КонстантаМенеджер = Константы[КонстантаИмя];
		КонстантаЗначение = НаборКонстант[КонстантаИмя];
		
		Если КонстантаМенеджер.Получить() <> КонстантаЗначение Тогда
			КонстантаМенеджер.Установить(КонстантаЗначение);
		КонецЕсли;
		
		СтандартныеПодсистемыКлиентСервер.РезультатВыполненияДобавитьОповещениеОткрытыхФорм(Результат, "Запись_НаборКонстант", Новый Структура, КонстантаИмя);
		// СтандартныеПодсистемы.ВариантыОтчетов
		ВариантыОтчетов.ДобавитьОповещениеПриИзмененииЗначенияКонстанты(Результат, КонстантаМенеджер);
		// Конец СтандартныеПодсистемы.ВариантыОтчетов
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступность(РеквизитПутьКДанным = "")
	
	// СтандартныеПодсистемы.ФайловыеФункции
	Если РеквизитПутьКДанным = "НаборКонстант.ХранитьФайлыВТомахНаДиске" ИЛИ РеквизитПутьКДанным = "" Тогда
		Элементы.СправочникТомаХраненияФайлов.Доступность = НаборКонстант.ХранитьФайлыВТомахНаДиске;
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ФайловыеФункции
	
	// СтандартныеПодсистемы.ФайловыеФункции
	Если РеквизитПутьКДанным = "НаборКонстант.ЗапрещатьЗагрузкуФайловПоРасширению" ИЛИ РеквизитПутьКДанным = "" Тогда
		Элементы.СписокЗапрещенныхРасширенийОбластиДанных.Доступность = НаборКонстант.ЗапрещатьЗагрузкуФайловПоРасширению;
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ФайловыеФункции
	
	// СтандартныеПодсистемы.ЭлектроннаяЦифроваяПодпись
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьЭлектронныеЦифровыеПодписи" ИЛИ РеквизитПутьКДанным = "" Тогда
		Элементы.ОбщаяФормаНастройкиЭЦП.Доступность = НаборКонстант.ИспользоватьЭлектронныеЦифровыеПодписи;
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ЭлектроннаяЦифроваяПодпись
	
КонецПроцедуры
