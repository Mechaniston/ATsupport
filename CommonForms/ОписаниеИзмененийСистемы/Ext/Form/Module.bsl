﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Заголовок = НСтр("ru = 'Что нового в конфигурации %1'");
	Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Заголовок, Метаданные.Синоним);
	
	Если ЗначениеЗаполнено(Параметры.ВремяНачалаОбновления) Тогда
		ВремяНачалаОбновления = Параметры.ВремяНачалаОбновления;
		ВремяОкончанияОбновления = Параметры.ВремяОкончанияОбновления;
	КонецЕсли;
	
	Разделы = ОбновлениеИнформационнойБазы.НеотображавшиесяРазделыОписанияИзменений();
	ПоследняяВерсия = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ОбновлениеИБ",
		"ПоследняяВерсияОтображенияИзмененийСистемы", , , ИмяПользователя());
	
	Если Разделы.Количество() = 0 Тогда
		ДокументОписаниеОбновлений = Метаданные.ОбщиеМакеты.Найти("ОписаниеИзмененийСистемы");
		Если ДокументОписаниеОбновлений <> Неопределено
			И (ПоследняяВерсия = Неопределено
				Или Не Параметры.ПоказыватьТолькоИзменения) Тогда
			ДокументОписаниеОбновлений = ПолучитьОбщийМакет(ДокументОписаниеОбновлений);
		Иначе
			ДокументОписаниеОбновлений = Новый ТабличныйДокумент();
		КонецЕсли;
	Иначе
		ДокументОписаниеОбновлений = ОбновлениеИнформационнойБазы.ДокументОписаниеОбновлений(Разделы);
	КонецЕсли;

	Если ДокументОписаниеОбновлений.ВысотаТаблицы = 0 Тогда
		Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Конфигурация успешно обновлена на версию %1'"), Метаданные.Версия);
		ДокументОписаниеОбновлений.Область("R1C1:R1C1").Текст = Текст;
	КонецЕсли;
	
	ОписанияПодсистем  = СтандартныеПодсистемыПовтИсп.ОписанияПодсистем();
	Для каждого ИмяПодсистемы Из ОписанияПодсистем.Порядок Цикл
		ОписаниеПодсистемы = ОписанияПодсистем.ПоИменам.Получить(ИмяПодсистемы);
		Если НЕ ЗначениеЗаполнено(ОписаниеПодсистемы.ОсновнойСерверныйМодуль) Тогда
			Продолжить;
		КонецЕсли;
		Модуль = ОбщегоНазначенияКлиентСервер.ОбщийМодуль(ОписаниеПодсистемы.ОсновнойСерверныйМодуль);
		Модуль.ПриПодготовкеМакетаОписанияОбновлений(ДокументОписаниеОбновлений);
	КонецЦикла;
	ОбновлениеИнформационнойБазыПереопределяемый.ПриПодготовкеМакетаОписанияОбновлений(ДокументОписаниеОбновлений);
	
	ОписаниеОбновлений.Очистить();
	ОписаниеОбновлений.Вывести(ДокументОписаниеОбновлений);
	
	СведенияОбОбновлении = ОбновлениеИнформационнойБазы.СведенияОбОбновленииИнформационнойБазы();
	Если СведенияОбОбновлении <> Неопределено Тогда
		ВремяНачалаОбновления = СведенияОбОбновлении.ВремяНачалаОбновления;
		ВремяОкончанияОбновления = СведенияОбОбновлении.ВремяОкончанияОбновления;
	КонецЕсли;
	
	Если Не ОбщегоНазначенияПовтИсп.ДоступноИспользованиеРазделенныхДанных()
		Или СведенияОбОбновлении = Неопределено
		Или СведенияОбОбновлении.ОтложенноеОбновлениеЗавершеноУспешно <> Неопределено
		Или СведенияОбОбновлении.ДеревоОбработчиков <> Неопределено
			И СведенияОбОбновлении.ДеревоОбработчиков.Строки.Количество() = 0 Тогда
		Элементы.ОтложенноеОбновление.Видимость = Ложь;
	КонецЕсли;
	
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		ЗаголовокСообщения = НСтр("ru = 'Необходимо выполнить дополнительные процедуры обработки данных'");
		Элементы.ОтложенноеОбновлениеДанных.Заголовок = ЗаголовокСообщения;
	КонецЕсли;
	
	Если Не Пользователи.ЭтоПолноправныйПользователь(, Истина) Тогда
		Элементы.ОтложенноеОбновлениеДанных.Заголовок =
			НСтр("ru = 'Не выполнены дополнительные процедуры обработки данных'");
		Элементы.ОтложенноеОбновлениеДанныхПояснение.Заголовок = 
			НСтр("ru = 'Работа в программе временно ограничена, так как еще не завершен переход на новую версию, обратитесь к администратору.'");
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ВремяНачалаОбновления) И Не ЗначениеЗаполнено(ВремяОкончанияОбновления) Тогда
		Элементы.ТехническаяИнформацияОРезультатахОбновления.Видимость = Ложь;
	ИначеЕсли Пользователи.ЭтоПолноправныйПользователь() И Не ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		Элементы.АдресФормыВПрограмме.ВысотаЗаголовка = 2;
		Элементы.ТехническаяИнформацияОРезультатахОбновления.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	ЗаписатьТекущиеНастройки();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ОписаниеОбновленийВыбор(Элемент, Область, СтандартнаяОбработка)
	
	Если Найти(Область.Текст, "http://") = 1 Или Найти(Область.Текст, "https://") = 1 Тогда
		ПерейтиПоНавигационнойСсылке(Область.Текст);
	КонецЕсли;
	
	ОбновлениеИнформационнойБазыКлиентПереопределяемый.ПриНажатииНаГиперссылкуВДокументеОписанияОбновлений(Область);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьСведенияОРезультатахОбновленияНажатие(Элемент)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ПоказатьОшибкиИПредупреждения", Истина);
	ПараметрыФормы.Вставить("ДатаНачала", ВремяНачалаОбновления);
	ПараметрыФормы.Вставить("ДатаОкончания", ВремяОкончанияОбновления);
	
	ОткрытьФорму("Обработка.ЖурналРегистрации.Форма.ЖурналРегистрации", ПараметрыФормы);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ОтложенноеОбновлениеДанных(Команда)
	ОткрытьФорму("Обработка.ОбновлениеИнформационнойБазы.Форма.ИндикацияХодаОтложенногоОбновленияИБ");
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервереБезКонтекста
Процедура ЗаписатьТекущиеНастройки()
	
	ОбновлениеИнформационнойБазы.УстановитьФлагОтображенияОписанийПоТекущуюВерсию();
	
КонецПроцедуры

