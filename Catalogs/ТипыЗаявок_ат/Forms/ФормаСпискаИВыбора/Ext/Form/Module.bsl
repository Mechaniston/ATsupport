﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УправляемыеФормы_Сервер_ат.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	Список.Параметры.УстановитьЗначениеПараметра("Клиент", ВнутреннегоИспользования_КлиентСерверПовтИсп_ат.СотрудникКлиента());
	
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