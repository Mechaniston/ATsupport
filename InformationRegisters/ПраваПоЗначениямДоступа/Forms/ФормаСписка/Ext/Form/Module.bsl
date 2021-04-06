﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Чтение = Истина;
	
	ТолькоПросмотр = Истина;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ВключитьВозможностьРедактирования(Команда)
	
	ТолькоПросмотр = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьВспомогательныеДанныеРегистра(Команда)
	
	ЕстьИзменения = Ложь;
	
	ОбновитьВспомогательныеДанныеРегистраНаСервере(ЕстьИзменения);
	
	Если ЕстьИзменения Тогда
		Текст = НСтр("ru = 'Обновление выполнено успешно.'");
	Иначе
		Текст = НСтр("ru = 'Обновление не требуется.'");
	КонецЕсли;
	
	Предупреждение(Текст);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ОбновитьВспомогательныеДанныеРегистраНаСервере(ЕстьИзменения)
	
	УстановитьПривилегированныйРежим(Истина);
	
	РегистрыСведений.ПраваПоЗначениямДоступа.ОбновитьВспомогательныеДанныеРегистра(ЕстьИзменения);
	
	Элементы.Список.Обновить();
	
КонецПроцедуры
