﻿
&НаКлиенте
Процедура ОтправитьПолучитьПочту_ат(Команда)
	//Ольхин Август 2013
	// Вставить содержимое обработчика.
	
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗначениеВРеквизитФормы(Метки_Сервер_ат.ПолучитьПолнуюТаблицуЗначенийОтбора("Справочник.Метки_ат"),
							"ТаблицаЗначенийОтбора");
	
	Метки_Сервер_ат.СоздатьКнопкуНастройкиОтбора(КоманднаяПанель, "Справочник.Метки_ат", "НастроитьОтборы", ЭтаФорма, "Установить отбор");
	
КонецПроцедуры
	
&НаКлиенте
Процедура НастроитьОтборы(Команда)
	
	ОписаниеОповещенияОЗакрытииФормы = Новый ОписаниеОповещения("УстановитьОтборыПослеНастройки", Метки_Клиент_ат);
	
	ПараметрыМеток = Новый Структура;
	ПараметрыМеток.Вставить("ИмяОбъектаМетаданных",				"Справочник.Метки_ат");
	ПараметрыМеток.Вставить("ТаблицаЗначенийОтбора",			ПреобразоватьТаблицуЗначенийВМассивСтруктур());
	ПараметрыМеток.Вставить("ДобавлятьНулевоеЗначение",			ОтображатьПустые);
	ПараметрыМеток.Вставить("ИмяРеквизитаОтбора",				"КлючОтбораПоТегам");
	ПараметрыМеток.Вставить("ОтбиратьПоКлючу",					Истина);
	ПараметрыМеток.Вставить("ВключитьОтборПоПроекту",			Истина);
	ПараметрыМеток.Вставить("ТипЗначенияОбъекта",				Тип("ДокументСсылка.ЭлектронноеПисьмоВходящее"));
	ПараметрыМеток.Вставить("ТипЗначенияМеток",					Тип("СправочникСсылка.Метки_ат"));
	ПараметрыМеток.Вставить("Форма",							ЭтаФорма);
	ПараметрыМеток.Вставить("ОписаниеОповещенияОЗакрытииФормы",	ОписаниеОповещенияОЗакрытииФормы);
	
	Метки_Клиент_ат.ОбработчикКомандНастройкиОтборов(Команда, ПараметрыМеток);
	
КонецПроцедуры

&НаСервере
Функция ПреобразоватьТаблицуЗначенийВМассивСтруктур()
	
	ТаблицаЗначений = РеквизитФормыВЗначение("ТаблицаЗначенийОтбора");
	
	Колонки = ТаблицаЗначений.Колонки;
	
	МассивСтруктур = Новый Массив;
	
	Для Каждого СтрокаТаблицыЗначений Из ТаблицаЗначений Цикл
		
		СтрокаТаблицы = Новый Структура;
		
		Для Каждого Колонка Из Колонки Цикл
			
			ИмяКолонки = Колонка.Имя;
			СтрокаТаблицы.Вставить(ИмяКолонки, СтрокаТаблицыЗначений[ИмяКолонки]);
			
		КонецЦикла;
		
		МассивСтруктур.Добавить(СтрокаТаблицы);
		
	КонецЦикла;
	
	Возврат МассивСтруктур;
	
КонецФункции

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Метки_КлиентСервер_ат.УстановитьОтборСпискаПоТаблицеЗначений(Список, Тип("ДокументСсылка.ЭлектронноеПисьмоВходящее"),
		Тип("СправочникСсылка.Метки_ат"), "Ссылка", ТаблицаЗначенийОтбора,, ОтображатьПустые,,
		Элементы.ГруппаОтбораПоМеткам, Элементы.ГруппаОтбораПоМеткам.Подсказка);
	
КонецПроцедуры
	

