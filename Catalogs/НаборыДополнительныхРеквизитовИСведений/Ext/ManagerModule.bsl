﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЙ ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Обновляет состав наименований предопределенных наборов в
// параметрах дополнительных реквизитов и сведений.
// 
// Параметры:
//  ЕстьИзменения - Булево (возвращаемое значение) - если производилась запись,
//                  устанавливается Истина, иначе не изменяется.
//
Процедура ОбновитьСоставНаименованийПредопределенныхНаборов(ЕстьИзменения = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ПредопределенныеНаборы = ПредопределенныеНаборы();
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("Константа.ПараметрыДополнительныхРеквизитовИСведений");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	
	НачатьТранзакцию();
	Попытка
		Блокировка.Заблокировать();
		
		Параметры = ОбновлениеИнформационнойБазы.ПараметрыРаботыПрограммы(
			"ПараметрыДополнительныхРеквизитовИСведений");
		
		ЕстьУдаленные = Ложь;
		Сохраненные = Неопределено;
		
		Если Параметры.Свойство("ПредопределенныеНаборыДополнительныхРеквизитовИСведений") Тогда
			Сохраненные = Параметры.ПредопределенныеНаборыДополнительныхРеквизитовИСведений;
			
			Если НЕ ПредопределенныеНаборыСовпадают(ПредопределенныеНаборы, Сохраненные, ЕстьУдаленные) Тогда
				Сохраненные = Неопределено;
			КонецЕсли;
		КонецЕсли;
		
		Если Сохраненные = Неопределено Тогда
			ЕстьИзменения = Истина;
			ОбновлениеИнформационнойБазы.УстановитьПараметрРаботыПрограммы(
				"ПараметрыДополнительныхРеквизитовИСведений",
				"ПредопределенныеНаборыДополнительныхРеквизитовИСведений",
				ПредопределенныеНаборы);
		КонецЕсли;
		
		ОбновлениеИнформационнойБазы.ДобавитьИзмененияПараметраРаботыПрограммы(
			"ПараметрыДополнительныхРеквизитовИСведений",
			"ПредопределенныеНаборыДополнительныхРеквизитовИСведений",
			Новый ФиксированнаяСтруктура("ЕстьУдаленные", ЕстьУдаленные));
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

Функция ПредопределенныеНаборы()
	
	ПредопределенныеНаборы = Новый Соответствие;
	
	ИменаПредопределенных = СтандартныеПодсистемыСервер.ИменаПредопределенныхДанных(
		"Справочник.НаборыДополнительныхРеквизитовИСведений");
	
	Для каждого Имя Из ИменаПредопределенных Цикл
		ПредопределенныеНаборы.Вставить(
			Имя, УправлениеСвойствамиСлужебный.НаименованиеПредопределенногоНабора(Имя));
	КонецЦикла;
	
	Возврат Новый ФиксированноеСоответствие(ПредопределенныеНаборы);
	
КонецФункции

Функция ПредопределенныеНаборыСовпадают(НовыеНаборы, СтарыеНаборы, ЕстьУдаленные)
	
	ПредопределенныеНаборыСовпадают =
		НовыеНаборы.Количество() = СтарыеНаборы.Количество();
	
	Для каждого Набор Из СтарыеНаборы Цикл
		Если НовыеНаборы.Получить(Набор.Ключ) = Неопределено Тогда
			ПредопределенныеНаборыСовпадают = Ложь;
			ЕстьУдаленные = Истина;
			Прервать;
		ИначеЕсли Набор.Значение <> НовыеНаборы.Получить(Набор.Ключ) Тогда
			ПредопределенныеНаборыСовпадают = Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ПредопределенныеНаборыСовпадают;
	
КонецФункции

#КонецЕсли
