﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбновитьСписокОбъектов();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПодключитьОбработчикОжидания("Обновление", 60);
	
КонецПроцедуры

&НаКлиенте
Процедура Обновление()
	
	ОбновитьСписокОбъектов();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокОбъектов()
	
	СписокОбъектов.Очистить();
	
	Подключения = ПолучитьИзВременногоХранилища(ПодключениеКИБ_ПовтИсп_ат.ПолучитьАдресХранилищаПодключений());
	
	Для Каждого Подключение Из Подключения Цикл 
		СтрокаСоединения = Подключение.Значение.СтрокаСоединенияИнформационнойБазы();
		
		СтрокаСоединения = СтрЗаменить(СтрокаСоединения, "Srvr=""", "");
		Позиция = Найти(СтрокаСоединения,"""");
		ИмяСервера = Лев(СтрокаСоединения, Позиция - 1);
		
		СтрокаСоединения = СтрЗаменить(СтрокаСоединения, ИмяСервера +""";Ref=""", "");
		Позиция = Найти(СтрокаСоединения,""";");
		ИмяБазы = Лев(СтрокаСоединения, Позиция - 1);
		
		НовСтр = СписокОбъектов.Добавить();
		НовСтр.Ключ = Подключение.Ключ;
		НовСтр.ИмяСервера = ИмяСервера;
		НовСтр.ИмяБазы = ИмяБазы;
	КонецЦикла;
	
КонецПроцедуры	

&НаКлиенте
Процедура Подключиться(Команда)
	
	РезультатПодключения = ПодключитьсяКИнформационнойБазе();
	
	Если РезультатПодключения = "Успешно" Тогда 
		Сообщить("Подключение к информационной базе произошло успешно", СтатусСообщения.Информация);
		ПодключениеКИБ_Клиент_ат.ПроверятьСоединения();
	Иначе
		Сообщить(РезультатПодключения, СтатусСообщения.Важное);
	КонецЕсли;
	
	Обновление();
		
КонецПроцедуры

&НаСервере
Функция   ПодключитьсяКИнформационнойБазе()
	
	База = ЭтаФорма.БазаДляПодключения;

	Если Не ЗначениеЗаполнено(База) Тогда
		Возврат "Выберите базу для подключения.";
	КонецЕсли;
	
	РезультатПодключения = ПодключениеКИБ_ат.УстановитьПодключение(База);
	
	Если ТипЗнч(РезультатПодключения) = Тип("COMОбъект") Тогда
		Возврат "Успешно";
	Иначе
		Возврат РезультатПодключения;
	КонецЕсли;

КонецФункции	

&НаКлиенте
Процедура ОбновитьСписок(Команда)
	
	Обновление();
	
КонецПроцедуры

&НаКлиенте
Процедура РазорватьВыбранные(Команда)
	
	УдалитьВыбраные();
	Обновление();

КонецПроцедуры

&НаСервере
Процедура УдалитьВыбраные()
	
	Подключения = ПолучитьИзВременногоХранилища(ПодключениеКИБ_ПовтИсп_ат.ПолучитьАдресХранилищаПодключений());
		
	Для Каждого Строка Из СписокОбъектов Цикл 
		Если Строка.Флаг Тогда
			Подключения.Удалить(Строка.Ключ);	
		КонецЕсли;	
	КонецЦикла;	

КонецПроцедуры	