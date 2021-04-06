﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// ХАК до создания аренды. Показывать и наши серваки .
	Если Параметры.Отбор.Количество() > 0 Тогда
		
		Элементы.Список.Отображение = ОтображениеТаблицы.Список;
		
		Если Параметры.Отбор.Свойство("КонтрагентВладелец") Тогда
			
			КонтрагентыВладельцы = КонтрагентыВладельцы();
			КонтрагентыВладельцы.Добавить(Параметры.Отбор.КонтрагентВладелец);
			
			Параметры.Отбор.КонтрагентВладелец = КонтрагентыВладельцы;
			
		КонецЕсли;
		
	Иначе
		
		Элементы.Список.Отображение = ОтображениеТаблицы.Дерево;
		
	КонецЕсли;
	
	УправляемыеФормы_Сервер_ат.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	Если Параметры.Свойство("ТипыРолейСерверов") Тогда
		
		Список.Параметры.УстановитьЗначениеПараметра("ТипыРолейСерверов", Параметры.ТипыРолейСерверов);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УправляемыеФормы_Клиент_ат.ПриОткрытии(ЭтаФорма, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	УправляемыеФормы_Клиент_ат.ПередЗакрытием(ЭтаФорма, Отказ, СтандартнаяОбработка, ЗавершениеРаботы, ТекстПредупреждения);
	
КонецПроцедуры

#КонецОбласти 

#Область УниверсальныеОбработчикиДействий

&НаКлиенте
Процедура ОбработчикУниверсальныхДействий(Команда)
	
	УправляемыеФормы_Клиент_ат.ДополнительныеДействияФормы(ЭтаФорма, Команда);
	
КонецПроцедуры

&НаСервере
Функция   ОбработчикУниверсальныхДействий_Сервер(Элемент) Экспорт
	
	Возврат УправляемыеФормы_Сервер_ат.ДополнительныеДействияФормы(ЭтаФорма, Команды[Элемент.Имя]);
	
КонецФункции

#КонецОбласти

&НаСервере
Функция   КонтрагентыВладельцы()
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДополнительныеРеквизитыОрганизаций_ат.Контрагент
	|ИЗ
	|	РегистрСведений.ДополнительныеРеквизитыОрганизаций_ат КАК ДополнительныеРеквизитыОрганизаций_ат
	|ГДЕ
	|	НЕ ДополнительныеРеквизитыОрганизаций_ат.Контрагент = ЗНАЧЕНИЕ(Справочник.Контрагенты_ат.ПустаяСсылка)";
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Контрагент");
	
КонецФункции