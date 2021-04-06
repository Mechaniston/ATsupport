﻿
Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	ЭлементыПараметровКомпановкиДанных = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы;
	Если ЗначениеЗаполнено(ДатаНач) Тогда
		
		Для Каждого Параметр Из ЭлементыПараметровКомпановкиДанных Цикл
			
			Если Строка(Параметр.Параметр) = "ДатаНач" Тогда
				
				Параметр.Значение = ДатаНач;
				Параметр.Использование = Истина;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДатаКон) Тогда
		
		Для Каждого Параметр Из ЭлементыПараметровКомпановкиДанных Цикл
			
			Если Строка(Параметр.Параметр) = "ДатаКон" Тогда
				
				Параметр.Значение = ДатаКон;
				Параметр.Использование = Истина;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры
