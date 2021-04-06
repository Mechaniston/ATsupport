﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ Параметры.Свойство("ОткрытаПоСценарию") Тогда
		ВызватьИсключение НСтр("ru='Обработка не предназначена для непосредственного использования.'");
	КонецЕсли;
	
	Если НЕ УправлениеИтогамиИАгрегатамиСлужебный.НадоСдвинутьГраницуИтогов() Тогда
		Отказ = Истина; // Период уже был установлен в сеансе другого пользователя.
		Возврат;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ПодключитьОбработчикОжидания("УстановкаПериодаРассчитанныхИтогов", 0.1, Истина);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура УстановкаПериодаРассчитанныхИтогов()
	ВремяНачала = ОбщегоНазначенияКлиент.ДатаСеанса();
	УстановкаПериодаРассчитанныхИтоговНаСервереБезКонтекста();
	СкоростьВыполненияВСекундах = ОбщегоНазначенияКлиент.ДатаСеанса() - ВремяНачала;
	Если СкоростьВыполненияВСекундах >= 5 Тогда
		Закрыть();
	Иначе
		ПодключитьОбработчикОжидания("ЗакрытьФорму", 5 - СкоростьВыполненияВСекундах, Истина);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФорму()
	Закрыть();
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УстановкаПериодаРассчитанныхИтоговНаСервереБезКонтекста()
	УстановитьПривилегированныйРежим(Истина);
	УправлениеИтогамиИАгрегатамиСлужебный.УстановкаПериодаРассчитанныхИтогов();
КонецПроцедуры
