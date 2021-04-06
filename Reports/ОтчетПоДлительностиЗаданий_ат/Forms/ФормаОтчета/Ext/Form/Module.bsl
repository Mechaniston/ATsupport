﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Для Каждого Элемент Из Отчет.КомпоновщикНастроек.Настройки.ДоступныеПоляГруппировок.Элементы Цикл
		Отчет.Группировки.Добавить(Элемент.Поле, Элемент.Заголовок);
	КонецЦикла;
	
	Для Каждого Элемент Из Отчет.КомпоновщикНастроек.Настройки.ДоступныеПоляВыбора.Элементы Цикл
		Если НЕ Элемент.Ресурс Тогда
			Если Элемент.Заголовок = "Системные поля" Тогда
				Отчет.Поля.Вставить(0, Элемент.Элементы[0].Поле, Элемент.Элементы[0].Заголовок);
				Отчет.Поля.Вставить(1, Элемент.Элементы[1].Поле, Элемент.Элементы[1].Заголовок);
			Иначе	
				Отчет.Поля.Добавить(Элемент.Поле, Элемент.Заголовок);
			КонецЕсли;
		КонецЕсли;	
	КонецЦикла;
	
КонецПроцедуры

