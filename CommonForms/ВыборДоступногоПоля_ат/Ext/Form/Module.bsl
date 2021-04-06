﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Режим = Параметры.Режим;
	ИсключенныеПоля = Параметры.ИсключенныеПоля;
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(Параметры.СхемаКомпоновкиДанных));
	
	Если Режим = "Группировка" Тогда
		ФиктивнаяСтрокаГруппировка = КомпоновщикНастроек.Настройки.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
		Элементы.Настройки.ТекущаяСтрока = КомпоновщикНастроек.Настройки.ПолучитьИдентификаторПоОбъекту(ФиктивнаяСтрокаГруппировка);
		
		Элементы.ГруппаДоступныеПоляВыбор.Видимость   = Ложь;
		Элементы.ГруппаДоступныеПоляОтбор.Видимость   = Ложь;
		Элементы.ГруппаДоступныеПоляПорядок.Видимость = Ложь;
		Заголовок = НСтр("ru = 'Выбор поля группировки'");

		Для Каждого Поле Из Параметры.ИсключенныеПоля Цикл
			Ограничение = Элементы.ДоступныеПоляПолейГруппировок.ОграниченияИспользования.Добавить();
			Ограничение.Доступность = Ложь;
			Ограничение.Поле = Новый ПолеКомпоновкиДанных(Поле);
		КонецЦикла;				
		Если Параметры.ТекущаяСтрока <> Неопределено Тогда
			ДоступноеПоле = КомпоновщикНастроек.Настройки.ДоступныеПоляГруппировок.НайтиПоле(Новый ПолеКомпоновкиДанных(Параметры.ТекущаяСтрока));
			Идентификатор = КомпоновщикНастроек.Настройки.ДоступныеПоляГруппировок.ПолучитьИдентификаторПоОбъекту(ДоступноеПоле);
			Элементы.ДоступныеПоляПолейГруппировок.ТекущаяСтрока = Идентификатор;		
		КонецЕсли;
	ИначеЕсли Режим = "Выбор" Тогда
		Элементы.ГруппаДоступныеПоляГруппировка.Видимость = Ложь;
		Элементы.ГруппаДоступныеПоляОтбор.Видимость       = Ложь;
		Элементы.ГруппаДоступныеПоляПорядок.Видимость     = Ложь;
		Заголовок = НСтр("ru = 'Выбор поля'");
		
		Для Каждого Поле Из Параметры.ИсключенныеПоля Цикл
			Ограничение = Элементы.ДоступныеПоляВыбора.ОграниченияИспользования.Добавить();
			Ограничение.Доступность = Ложь;
			Ограничение.Поле = Новый ПолеКомпоновкиДанных(Поле);
		КонецЦикла;		
		Если Параметры.ТекущаяСтрока <> Неопределено Тогда
			ДоступноеПоле = КомпоновщикНастроек.Настройки.ДоступныеПоляВыбора.НайтиПоле(Новый ПолеКомпоновкиДанных(Параметры.ТекущаяСтрока));
			Идентификатор = КомпоновщикНастроек.Настройки.ДоступныеПоляВыбора.ПолучитьИдентификаторПоОбъекту(ДоступноеПоле);
			Элементы.ДоступныеПоляВыбора.ТекущаяСтрока = Идентификатор;		
		КонецЕсли;
	ИначеЕсли Режим = "Отбор" Тогда
		Элементы.ГруппаДоступныеПоляГруппировка.Видимость = Ложь;
		Элементы.ГруппаДоступныеПоляВыбор.Видимость       = Ложь;
		Элементы.ГруппаДоступныеПоляПорядок.Видимость     = Ложь;
		Заголовок = НСтр("ru = 'Выбор поля отбора'");
		
		Для Каждого Поле Из Параметры.ИсключенныеПоля Цикл
			Ограничение = Элементы.ДоступныеПоляОтбора.ОграниченияИспользования.Добавить();
			Ограничение.Доступность = Ложь;
			Ограничение.Поле = Новый ПолеКомпоновкиДанных(Поле);
		КонецЦикла;		
		Если Параметры.ТекущаяСтрока <> Неопределено Тогда
			ДоступноеПоле = КомпоновщикНастроек.Настройки.ДоступныеПоляОтбора.НайтиПоле(Новый ПолеКомпоновкиДанных(Параметры.ТекущаяСтрока));
			Идентификатор = КомпоновщикНастроек.Настройки.ДоступныеПоляОтбора.ПолучитьИдентификаторПоОбъекту(ДоступноеПоле);
			Элементы.ДоступныеПоляОтбора.ТекущаяСтрока = Идентификатор;		
		КонецЕсли;
	ИначеЕсли Режим = "Порядок" Тогда
		Элементы.ГруппаДоступныеПоляГруппировка.Видимость = Ложь;
		Элементы.ГруппаДоступныеПоляВыбор.Видимость       = Ложь;
		Элементы.ГруппаДоступныеПоляОтбор.Видимость       = Ложь;
		Заголовок = НСтр("ru = 'Выбор поля сортировки'");
		
		Для Каждого Поле Из Параметры.ИсключенныеПоля Цикл
			Ограничение = Элементы.ДоступныеПоляПорядка.ОграниченияИспользования.Добавить();
			Ограничение.Доступность = Ложь;
			Ограничение.Поле = Новый ПолеКомпоновкиДанных(Поле);
		КонецЦикла;		
		Если Параметры.ТекущаяСтрока <> Неопределено Тогда
			ДоступноеПоле = КомпоновщикНастроек.Настройки.ДоступныеПоляПорядка.НайтиПоле(Новый ПолеКомпоновкиДанных(Параметры.ТекущаяСтрока));
			Идентификатор = КомпоновщикНастроек.Настройки.ДоступныеПоляПорядка.ПолучитьИдентификаторПоОбъекту(ДоступноеПоле);
			Элементы.ДоступныеПоляПорядка.ТекущаяСтрока = Идентификатор;		
		КонецЕсли;
	КонецЕсли;
	
	Для Каждого Поле Из ИсключенныеПоля Цикл
		Если Режим = "Группировка" Тогда
			Ограничение = Элементы.ДоступныеПоляПолейГруппировок.ОграниченияИспользования.Добавить();
		ИначеЕсли Режим = "Выбор" Тогда
			Ограничение = Элементы.ДоступныеПоляВыбора.ОграниченияИспользования.Добавить();
		ИначеЕсли Режим = "Отбор" Тогда
			Ограничение = Элементы.ДоступныеПоляОтбора.ОграниченияИспользования.Добавить();
		ИначеЕсли Режим = "Порядок" Тогда
			Ограничение = Элементы.ДоступныеПоляПорядка.ОграниченияИспользования.Добавить();	
		КонецЕсли;
		Ограничение.Доступность = Ложь;
		Ограничение.Поле = Новый ПолеКомпоновкиДанных(Поле);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОК(Команда)
	
	ТекущиеДанные = Неопределено;
	Если Режим = "Группировка" Тогда
		ТекущиеДанные = Элементы.ДоступныеПоляПолейГруппировок.ТекущаяСтрока;
		ДоступноеПоле = КомпоновщикНастроек.Настройки.ДоступныеПоляГруппировок.ПолучитьОбъектПоИдентификатору(ТекущиеДанные);
	ИначеЕсли Режим = "Выбор" Тогда
		ТекущиеДанные = Элементы.ДоступныеПоляВыбора.ТекущаяСтрока;
		ДоступноеПоле = КомпоновщикНастроек.Настройки.ДоступныеПоляВыбора.ПолучитьОбъектПоИдентификатору(ТекущиеДанные);
	ИначеЕсли Режим = "Отбор" Тогда
		ТекущиеДанные = Элементы.ДоступныеПоляОтбора.ТекущаяСтрока;
		ДоступноеПоле = КомпоновщикНастроек.Настройки.ДоступныеПоляОтбора.ПолучитьОбъектПоИдентификатору(ТекущиеДанные);
	ИначеЕсли Режим = "Порядок" Тогда
		ТекущиеДанные = Элементы.ДоступныеПоляПорядка.ТекущаяСтрока;
		ДоступноеПоле = КомпоновщикНастроек.Настройки.ДоступныеПоляПорядка.ПолучитьОбъектПоИдентификатору(ТекущиеДанные);
	КонецЕсли;
	
	Если Не ДоступноеПоле.Папка Тогда
		ПараметрыВыбранногоПоля = Новый Структура;
		ПараметрыВыбранногоПоля.Вставить("Поле"     , Строка(ДоступноеПоле.Поле));
		ПараметрыВыбранногоПоля.Вставить("Заголовок", ДоступноеПоле.Заголовок);
		Если Режим = "Отбор" Тогда
			Если ДоступноеПоле.ДоступныеВидыСравнения.Количество() > 0 Тогда
				ПараметрыВыбранногоПоля.Вставить("ВидСравнения", ДоступноеПоле.ДоступныеВидыСравнения[0].Значение);
			Иначе
				ПараметрыВыбранногоПоля.Вставить("ВидСравнения", ВидСравненияКомпоновкиДанных.Равно);
			КонецЕсли;
		КонецЕсли;
		
		Закрыть(ПараметрыВыбранногоПоля);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДоступныеПоляПолейГруппировокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	КомандаОК(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ДоступныеПоляВыбораВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	КомандаОК(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ДоступныеПоляПорядкаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	КомандаОК(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ДоступныеПоляОтбораВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	КомандаОК(Неопределено);
	
КонецПроцедуры
