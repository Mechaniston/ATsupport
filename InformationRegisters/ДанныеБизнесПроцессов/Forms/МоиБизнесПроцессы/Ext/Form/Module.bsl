﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	УстановитьОтбор(Новый Структура("ПоказыватьЗавершенные", ПоказыватьЗавершенные));
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "Автор", Пользователи.ТекущийПользователь());

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "Запись_ЗадачаИсполнителя" Тогда
		Элементы.Список.Обновить();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	УстановитьОтбор(Настройки);
		
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ПоказыватьЗавершенныеПриИзменении(Элемент)
	
	УстановитьОтбор(Новый Структура("ПоказыватьЗавершенные", ПоказыватьЗавершенные));
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ФОРМЫ Список

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Если Элементы.Список.ТекущиеДанные <> Неопределено Тогда
		ОткрытьЗначение(Элементы.Список.ТекущиеДанные.БизнесПроцесс);
 	КонецЕсли;
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	Если Элемент.ТекущиеДанные <> Неопределено Тогда
		ОткрытьЗначение(Элемент.ТекущиеДанные.БизнесПроцесс);
		Отказ = Истина;
 	КонецЕсли;      
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ПометкаУдаления(Команда)
	БизнесПроцессыИЗадачиКлиент.СписокБизнесПроцессовПометкаУдаления(Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура КартаМаршрута(Команда)
	Если Элементы.Список.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОткрытьФорму("Обработка.КартаМаршрутаБизнесПроцесса.Форма", 
		Новый Структура("БизнесПроцесс", Элементы.Список.ТекущиеДанные.БизнесПроцесс));
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура УстановитьОтбор(ПараметрыОтбора)
	
	ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(Список, "Завершен");
	
	Если НЕ ПараметрыОтбора["ПоказыватьЗавершенные"] Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "Завершен", Ложь, ВидСравненияКомпоновкиДанных.Равно, , ,
			РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ);
	КонецЕсли;
	
КонецПроцедуры

