﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если НЕ Параметры.Свойство("ОткрытаПоСценарию") Тогда
		ВызватьИсключение НСтр("ru='Обработка не предназначена для непосредственного использования.'");
	КонецЕсли;
	
	ДатаПоследнегоПоказа = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("НерекомендуемаяВерсияПлатформы", "ДатаПоследнегоОтображения",,, ИмяПользователя());
	
	ПоказатьСообщение = Истина;
	Если ДатаПоследнегоПоказа <> Неопределено Тогда
		ПоказатьСообщение = Формат(ДатаПоследнегоПоказа, "ДЛФ=D") <> Формат(ТекущаяДатаСеанса(), "ДЛФ=D");
	КонецЕсли;
	
	Если Не ПоказатьСообщение И Не ПараметрыСеанса.ВыполняетсяОбновлениеИБ Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Элементы.ТекстСообщения.Заголовок = Параметры.ТекстСообщения;
	Элементы.РекомендуемаяВерсияПлатформы.Заголовок = Параметры.РекомендуемаяВерсияПлатформы;
	СистемнаяИнформация = Новый СистемнаяИнформация;
	Элементы.Версия.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		Элементы.Версия.Заголовок, СистемнаяИнформация.ВерсияПриложения);
	Если Параметры.ЗавершитьРаботу Тогда
		Элементы.ТекстВопроса.Видимость = Ложь;
		Элементы.ФормаНет.Видимость     = Ложь;
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЭтоПлатформа83БезРежимаСовместимости() Тогда
		Выполнить("РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если Не ДействиеОпределено Тогда
		СтандартнаяОбработка = Ложь;
		ДействиеОпределено = Истина;
		ПрекратитьРаботуСистемы();
		Закрыть(КодВозвратаДиалога.ОК);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ТекстСсылкиНажатие(Элемент)
	СтандартнаяОбработка = Ложь;
	ОткрытьФорму("Обработка.НерекомендуемаяВерсияПлатформы.Форма.ПорядокОбновленияПлатформы");
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ПродолжитьРаботу(Команда)
	
	ДействиеОпределено = Истина;
	СохранитьДатуПоследнегоПоказа();
	Закрыть(КодВозвратаДиалога.Отмена);
	
	// СтандартныеПодсистемы.ОбновлениеВерсииИБ
	ОбновлениеИнформационнойБазыКлиент.ОбновитьИнформационнуюБазу();
	// Конец СтандартныеПодсистемы.ОбновлениеВерсииИБ
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьРаботу(Команда)
	
	ДействиеОпределено = Истина;
	ПрекратитьРаботуСистемы();
	Закрыть(КодВозвратаДиалога.ОК);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура СохранитьДатуПоследнегоПоказа()
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
		"НерекомендуемаяВерсияПлатформы", "ДатаПоследнегоОтображения", ТекущаяДатаСеанса(),, ИмяПользователя());
	
КонецПроцедуры


