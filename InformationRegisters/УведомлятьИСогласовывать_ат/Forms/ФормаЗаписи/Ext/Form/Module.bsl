﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.ЗначенияЗаполнения.Свойство("Сотрудник") Тогда
		
		Планирование_Сервер_ат.ПервичноеЗаполнениеСотрудникКлиентПодразделение(Запись.Сотрудник, Запись.Сотрудник, Запись.Клиент, Запись.Подразделение);
		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Запись.Клиент) И Параметры.ЗначенияЗаполнения.Свойство("Подразделение") Тогда
		
		Запись.Клиент = Параметры.ЗначенияЗаполнения.Подразделение.Владелец;
		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Запись.Клиент) И Параметры.ЗначенияЗаполнения.Свойство("Договор") Тогда
		
		Запись.Клиент = Параметры.ЗначенияЗаполнения.Договор.Владелец;
		
	КонецЕсли;
	
КонецПроцедуры
