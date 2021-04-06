﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Дерево = Метки_Сервер_ат.ПолучитьТаблицуСсылокНаИсточникиЗначенийВыбора(Параметры.ИмяОбъектаМетаданных,, Истина,
		?(ЗначениеЗаполнено(Параметры.Проекты), Параметры.Проекты, Неопределено));
	
	ДобавлятьНулевоеЗначение = Параметры.ДобавлятьНулевоеЗначение;
	
	Отказ = Дерево = Неопределено;
		
	Для Каждого СтрокатаблицыЗначенийОтбора Из Параметры.ТаблицаЗначенийОтбора Цикл
		
		СтрокаДерева = Дерево.Строки.Найти(СтрокатаблицыЗначенийОтбора.Значение,, Истина);
		Если НЕ СтрокаДерева = Неопределено Тогда
			
			СтрокаДерева.ИспользоватьИ	 = СтрокатаблицыЗначенийОтбора.ИспользоватьИ;
			СтрокаДерева.ИспользоватьИЛИ = СтрокатаблицыЗначенийОтбора.ИспользоватьИЛИ;
			СтрокаДерева.ИспользоватьНЕ	 = СтрокатаблицыЗначенийОтбора.ИспользоватьНЕ;
			
		КонецЕсли;
		
	КонецЦикла;
	
	ЗначениеВДанныеФормы(ДобавитьКонревойЭлементДерева(Дерево), ДеревоЭлементовОтбора);
	
	СформироватьПредставлениеОтбора();
	
	ТекущийЭлемент = Элементы.Поиск;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Элементы.ГруппироватьПоУсловию.Пометка = ГруппироватьПоУсловию;
	
	УстановитьИспользованиеРодителей(ДеревоЭлементовОтбора);
	ОбновитьВыбранныеМетки();
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавлятьНулевоеЗначениеПриИзменении(Элемент)
	
	СформироватьПредставлениеОтбора();
	
КонецПроцедуры

&НаСервере
Функция ДобавитьКонревойЭлементДерева(ИсходноеДерево)
	
	НовоеДерево = Новый ДеревоЗначений;
	
	Для Каждого Колонка Из ИсходноеДерево.Колонки Цикл
		
		НовоеДерево.Колонки.Добавить(Колонка.Имя, Колонка.ТипЗначения ,"ВСЕ");
		
	КонецЦикла;
	
	НоваяСтрока = НовоеДерево.Строки.Добавить();
	
	ПереместитьСтрокиДереваРекурсивно(НоваяСтрока, ИсходноеДерево.Строки);
	
	Возврат НовоеДерево;
	
КонецФункции

&НаСервере
Процедура ПереместитьСтрокиДереваРекурсивно(Родитель, СтрокиИсходногоДерева)
	
	Для Каждого СтрокаИсходногоДерева Из СтрокиИсходногоДерева Цикл
		
		НоваяСтрока = Родитель.Строки.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаИсходногоДерева,, "Родитель");
		ПереместитьСтрокиДереваРекурсивно(НоваяСтрока, СтрокаИсходногоДерева.Строки)
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Функция УстановитьИспользованиеРодителей(ТекущийЭлементДерева)
	
	ЭлементыДерева = ТекущийЭлементДерева.ПолучитьЭлементы();
	
	Для Каждого ЭлементДерева Из ЭлементыДерева Цикл
		
		Если ЭлементДерева.ИспользоватьИ Тогда
			
			УстановитьИспользованиеРодителя(ЭлементДерева.ПолучитьРодителя(), "ИспользоватьИ");
			
		ИначеЕсли ЭлементДерева.ИспользоватьИЛИ Тогда
			
			УстановитьИспользованиеРодителя(ЭлементДерева.ПолучитьРодителя(), "ИспользоватьИЛИ");
			
		ИначеЕсли ЭлементДерева.ИспользоватьНЕ Тогда
			
			УстановитьИспользованиеРодителя(ЭлементДерева.ПолучитьРодителя(), "ИспользоватьНЕ");
			
		Иначе
			
			УстановитьИспользованиеРодителей(ЭлементДерева);
			
		КонецЕсли;
		
	КонецЦикла;
		
КонецФункции

&НаКлиенте
Процедура УстановитьИспользованиеРодителя(Родитель, ИмяРеквизитаПометки = "Использовать", Использовать = Истина)
	
	Если НЕ Родитель = Неопределено Тогда
		
		Если НЕ Использовать Тогда
			
			Если ПодчиненныеИспользуются(ИмяРеквизитаПометки, Родитель) Тогда
				Использовать = Истина;
			КонецЕсли;
			
		КонецЕсли;
		
		Родитель[ИмяРеквизитаПометки] = Использовать;
		УстановитьИспользованиеРодителя(Родитель.ПолучитьРодителя(), ИмяРеквизитаПометки, Использовать);
			
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ПодчиненныеИспользуются(ИмяРеквизитаПометки, ТекущийЭлементДерева)
	
	ЭлементыДерева = ТекущийЭлементДерева.ПолучитьЭлементы();
	
	Для Каждого ПодчиненныйЭлемент Из ЭлементыДерева Цикл
		Если ПодчиненныйЭлемент[ИмяРеквизитаПометки] Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

&НаСервере
Функция ИзменитьИспользованиеОтборовВТаблице()
	
	Дерево = ДанныеФормыВЗначение(ДеревоЭлементовОтбора, Тип("ДеревоЗначений"));
	
	ТаблицаЗначенийОтбора = Новый Массив; // Массив структур, чтобы можно было передавать с клиента на сервер.
	
	Для Каждого СтрокаТаблицыЗначенийОтбора Из Параметры.ТаблицаЗначенийОтбора Цикл
		
		СтрокаДерева = Дерево.Строки.Найти(СтрокаТаблицыЗначенийОтбора.Значение,, Истина);
		Если НЕ СтрокаДерева = Неопределено Тогда
			
			СтрокаТаблицыЗначенийОтбора.Вставить("ИспользоватьИ",	СтрокаДерева.ИспользоватьИ);
			СтрокаТаблицыЗначенийОтбора.Вставить("ИспользоватьИЛИ", СтрокаДерева.ИспользоватьИЛИ);
			СтрокаТаблицыЗначенийОтбора.Вставить("ИспользоватьНЕ",	СтрокаДерева.ИспользоватьНЕ);
			
			ТаблицаЗначенийОтбора.Добавить(СтрокаТаблицыЗначенийОтбора);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ТаблицаЗначенийОтбора;
	
КонецФункции

&НаКлиенте
Процедура ИзменитьПометкиДерева(ТекущийЭлементДерева, ИмяРеквизитаПометки = "Использовать", Пометка, ЭтоУстановкаПометокВсемЭлементам = Ложь, ДанныеСтроки = Неопределено)
	
	ЭлементыДерева = ТекущийЭлементДерева.ПолучитьЭлементы();
	
	Если ДанныеСтроки = Неопределено Тогда
		ДанныеСтроки = Элементы.ДеревоЭлементовОтбора.ТекущиеДанные;
	КонецЕсли;
	
	Для Каждого ЭлементДерева Из ЭлементыДерева Цикл
		
		Если ЭтоУстановкаПометокВсемЭлементам
		 ИЛИ ЭлементДерева.Значение = ДанныеСтроки.Значение Тогда
		   
			УстановитьПометкиПодчиненных(ЭлементДерева, ИмяРеквизитаПометки, Пометка);
			ЭлементДерева[ИмяРеквизитаПометки] = Пометка;
			
		Иначе
			
			ИзменитьПометкиДерева(ЭлементДерева, ИмяРеквизитаПометки, Пометка, ЭтоУстановкаПометокВсемЭлементам, ДанныеСтроки);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПометкиПодчиненных(ТекущийЭлемент, ИмяРеквизитаПометки, Пометка)
	
	ЭлементыДерева = ТекущийЭлемент.ПолучитьЭлементы();
	
	Для Каждого ЭлементДерева Из ЭлементыДерева Цикл
		
		ЭлементДерева[ИмяРеквизитаПометки] = Пометка;
		УстановитьПометкиПодчиненных(ЭлементДерева, ИмяРеквизитаПометки, Пометка);
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура РазвернутьВсе()
	
   тЭлементы = ДеревоЭлементовОтбора.ПолучитьЭлементы();
   Для Каждого тСтр Из тЭлементы Цикл
      Элементы.ДеревоЭлементовОтбора.Развернуть(тСтр.ПолучитьИдентификатор(), Истина);
  КонецЦикла;
  
КонецПроцедуры

&НаКлиенте
Процедура ДеревоЭлементовОтбораИспользоватьИПриИзменении(Элемент)
	
	Для Каждого ВыделеннаяСтрока Из Элементы.ДеревоЭлементовОтбора.ВыделенныеСтроки Цикл
		
		Если ТипЗнч(ВыделеннаяСтрока) = Тип("Число") Тогда
            ДанныеСтроки = Элементы.ДеревоЭлементовОтбора.ДанныеСтроки(ВыделеннаяСтрока);
        Иначе
            ДанныеСтроки = ВыделеннаяСтрока;
		КонецЕсли;
		
		Если ДанныеСтроки <> ТекущийЭлемент.ТекущиеДанные Тогда // т.к. для текущий строки пометку меняет сама платформа
			ДанныеСтроки.ИспользоватьИЛИ = НЕ ДанныеСтроки.ИспользоватьИЛИ;
		КонецЕсли;
		
		//ТекущаяСтрокаДерева = Элементы.ДеревоЭлементовОтбора.ТекущиеДанные;
		ПриИзмененииИспользования("ИспользоватьИ", ДанныеСтроки);
		СнятьСоседниеПометки("ИспользоватьИ", ДанныеСтроки);
		
	КонецЦикла;
	
	СформироватьПредставлениеОтбора();
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоЭлементовОтбораИспользоватьИЛИПриИзменении(Элемент)
	
	Для Каждого ВыделеннаяСтрока Из Элементы.ДеревоЭлементовОтбора.ВыделенныеСтроки Цикл
		
		Если ТипЗнч(ВыделеннаяСтрока) = Тип("Число") Тогда
            ДанныеСтроки = Элементы.ДеревоЭлементовОтбора.ДанныеСтроки(ВыделеннаяСтрока);
        Иначе
            ДанныеСтроки = ВыделеннаяСтрока;
		КонецЕсли;
		
		Если ДанныеСтроки <> ТекущийЭлемент.ТекущиеДанные Тогда // т.к. для текущий строки пометку меняет сама платформа
			ДанныеСтроки.ИспользоватьИЛИ = НЕ ДанныеСтроки.ИспользоватьИЛИ;
		КонецЕсли;
		
		//ТекущаяСтрокаДерева = Элементы.ДеревоЭлементовОтбора.ТекущиеДанные;
		ПриИзмененииИспользования("ИспользоватьИЛИ", ДанныеСтроки);
		СнятьСоседниеПометки("ИспользоватьИЛИ", ДанныеСтроки);
		
	КонецЦикла;
	
	СформироватьПредставлениеОтбора();
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоЭлементовОтбораИспользоватьНЕПриИзменении(Элемент)
	
	Для Каждого ВыделеннаяСтрока Из Элементы.ДеревоЭлементовОтбора.ВыделенныеСтроки Цикл
		
		Если ТипЗнч(ВыделеннаяСтрока) = Тип("Число") Тогда
            ДанныеСтроки = Элементы.ДеревоЭлементовОтбора.ДанныеСтроки(ВыделеннаяСтрока);
        Иначе
            ДанныеСтроки = ВыделеннаяСтрока;
		КонецЕсли;
		
		Если ДанныеСтроки <> ТекущийЭлемент.ТекущиеДанные Тогда // т.к. для текущий строки пометку меняет сама платформа
			ДанныеСтроки.ИспользоватьИЛИ = НЕ ДанныеСтроки.ИспользоватьИЛИ;
		КонецЕсли;
		
		//ТекущаяСтрокаДерева = Элементы.ДеревоЭлементовОтбора.ТекущиеДанные;
		ПриИзмененииИспользования("ИспользоватьНЕ", ДанныеСтроки);
		СнятьСоседниеПометки("ИспользоватьНЕ", ДанныеСтроки);
		
	КонецЦикла;
	
	СформироватьПредставлениеОтбора();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииИспользования(ИмяТекущейПометки, ТекущаяСтрокаДерева)
	
	Использовать = ТекущаяСтрокаДерева[ИмяТекущейПометки];
	ИзменитьПометкиДерева(ДеревоЭлементовОтбора, ИмяТекущейПометки, Использовать,, ТекущаяСтрокаДерева);
	УстановитьИспользованиеРодителя(ТекущаяСтрокаДерева.ПолучитьРодителя(), ИмяТекущейПометки, Использовать);
		
КонецПроцедуры

&НаКлиенте
Процедура СнятьСоседниеПометки(ИмяТекущейПометки, ТекущаяСтрокаДерева)
		
	Если ИмяТекущейПометки = "ИспользоватьИ"
		И ТекущаяСтрокаДерева.ИспользоватьИ Тогда
		
		ТекущаяСтрокаДерева.ИспользоватьИЛИ = Ложь;
		ПриИзмененииИспользования("ИспользоватьИЛИ", ТекущаяСтрокаДерева);
		ТекущаяСтрокаДерева.ИспользоватьНЕ	= Ложь;
		ПриИзмененииИспользования("ИспользоватьНЕ", ТекущаяСтрокаДерева);
		
	ИначеЕсли ИмяТекущейПометки = "ИспользоватьИЛИ"
		И ТекущаяСтрокаДерева.ИспользоватьИЛИ  Тогда
		
		ТекущаяСтрокаДерева.ИспользоватьИ	= Ложь;
		ПриИзмененииИспользования("ИспользоватьИ", ТекущаяСтрокаДерева);
		ТекущаяСтрокаДерева.ИспользоватьНЕ	= Ложь;
		ПриИзмененииИспользования("ИспользоватьНЕ", ТекущаяСтрокаДерева);
		
	ИначеЕсли ИмяТекущейПометки = "ИспользоватьНЕ"
		И ТекущаяСтрокаДерева.ИспользоватьНЕ  Тогда
		
		ТекущаяСтрокаДерева.ИспользоватьИ	= Ложь;
		ПриИзмененииИспользования("ИспользоватьИ", ТекущаяСтрокаДерева);
		ТекущаяСтрокаДерева.ИспользоватьИЛИ	= Ложь;
		ПриИзмененииИспользования("ИспользоватьИЛИ", ТекущаяСтрокаДерева);
		
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьОтбор(Команда)
	
	ДобавлятьНулевоеЗначение = Ложь;
	
	ПерваяСтрокаДерева = ДеревоЭлементовОтбора.ПолучитьЭлементы()[0];
	ПерваяСтрокаДерева.ИспользоватьИ = Ложь;
	ИзменитьПометкиДерева(ДеревоЭлементовОтбора, "ИспользоватьИ", Ложь, Истина);
	ПерваяСтрокаДерева.ИспользоватьИЛИ = Ложь;
	ИзменитьПометкиДерева(ДеревоЭлементовОтбора, "ИспользоватьИЛИ", Ложь, Истина);
	ПерваяСтрокаДерева.ИспользоватьНЕ	= Ложь;
	ИзменитьПометкиДерева(ДеревоЭлементовОтбора, "ИспользоватьНЕ", Ложь, Истина);
	
	СформироватьПредставлениеОтбора();
	
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	
	ПараметрыЗакрытия = Новый Структура;
	ПараметрыЗакрытия.Вставить("Форма",								ВладелецФормы);
	ПараметрыЗакрытия.Вставить("ТаблицаЗначенийОтбора",				ИзменитьИспользованиеОтборовВТаблице());
	ПараметрыЗакрытия.Вставить("ИмяРеквизитаОтбора",				Параметры.ИмяРеквизитаОтбора);
	ПараметрыЗакрытия.Вставить("ОтбиратьПоКлючу",					Параметры.ОтбиратьПоКлючу);
	ПараметрыЗакрытия.Вставить("ИмяРеквизитаСпискаЗначенийОтборов", Параметры.ИмяРеквизитаСпискаЗначенийОтборов);
	ПараметрыЗакрытия.Вставить("ДобавлятьНулевоеЗначение",			ДобавлятьНулевоеЗначение);
	ПараметрыЗакрытия.Вставить("ТипЗначенияОбъекта",				Параметры.ТипЗначенияОбъекта);
	ПараметрыЗакрытия.Вставить("ТипЗначенияМеток",					Параметры.ТипЗначенияМеток);
	ПараметрыЗакрытия.Вставить("ПредставлениеОтбора",				ПредставлениеОтбора);
	Закрыть(ПараметрыЗакрытия);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

&НаСервере
Процедура СформироватьПредставлениеОтбора()
	
	ПредставлениеОтбора = Метки_ВызовСервера_ат.СформироватьПредставлениеОтбора(РеквизитФормыВЗначение("ДеревоЭлементовОтбора"), ДобавлятьНулевоеЗначение);
	ОбновитьВыбранныеМетки();
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьНастройку(Команда)
	
	ПараметрыОткрытияФормы = Новый Структура;
	ПараметрыОткрытияФормы.Вставить("СохраняемыеМетки", ПолучитьВыбранныеМеткиИзДерева());
	ПараметрыОткрытияФормы.Вставить("ВключаяНезаполненные", ДобавлятьНулевоеЗначение);
	ОткрытьФорму("Справочник.НастройкиМеток_ат.ФормаОбъекта", ПараметрыОткрытияФормы, ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьВыбранныеМеткиИзДерева()
	
	Дерево = РеквизитФормыВЗначение("ДеревоЭлементовОтбора");
	ВыбранныеМетки = Новый Массив;
	
	ПолучитьВыбранныеМеткиИзДереваРекурсивно(Дерево.Строки, ВыбранныеМетки);
	
	Возврат ВыбранныеМетки;
	
КонецФункции

&НаСервере
Процедура ПолучитьВыбранныеМеткиИзДереваРекурсивно(Строки, ВыбранныеМетки)
	
	Для Каждого Строка Из Строки Цикл
		
		Если ЗначениеЗаполнено(Строка.Значение) И НЕ Строка.Значение.ЭтоГруппа Тогда
			
			СтруктураМетки = Новый Структура;
			СтруктураМетки.Вставить("Значение", Строка.Значение);
			СтруктураМетки.Вставить("ИспользоватьИ", Строка.ИспользоватьИ);
			СтруктураМетки.Вставить("ИспользоватьИЛИ", Строка.ИспользоватьИЛИ);
			СтруктураМетки.Вставить("ИспользоватьНЕ", Строка.ИспользоватьНЕ);
			
			ВыбранныеМетки.Добавить(СтруктураМетки);
			
		КонецЕсли;
		
		ПолучитьВыбранныеМеткиИзДереваРекурсивно(Строка.Строки, ВыбранныеМетки)
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьНастройку(Команда)
	
	ПараметрыОткрытияФормы = Новый Структура;
	ПараметрыОткрытияФормы.Вставить("РежимВыбора", Истина);
	ОповещениеОВыборе = Новый ОписаниеОповещения("ЗагрузитьНастройкуПослеВыбора", ЭтаФорма);
	ОткрытьФорму("Справочник.НастройкиМеток_ат.ФормаВыбора", ПараметрыОткрытияФормы, ЭтаФорма,,,, ОповещениеОВыборе, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьНастройкуПослеВыбора(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗагрузитьНастройкуПослеВыбора_НаСервере(Результат);
	СформироватьПредставлениеОтбора();
	РазвернутьВсе();
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьНастройкуПослеВыбора_НаСервере(Результат)
	
	Дерево = РеквизитФормыВЗначение("ДеревоЭлементовОтбора");
	
	Для Каждого СтруктураВыбраннойМетки Из Результат.ВыбранныеМетки Цикл
		
		СтрокаДерева = Дерево.Строки.Найти(СтруктураВыбраннойМетки.Значение,, Истина);
		Если НЕ СтрокаДерева = Неопределено Тогда
			
			СтрокаДерева.ИспользоватьИ	 = СтруктураВыбраннойМетки.ИспользоватьИ;
			СтрокаДерева.ИспользоватьИЛИ = СтруктураВыбраннойМетки.ИспользоватьИЛИ;
			СтрокаДерева.ИспользоватьНЕ	 = СтруктураВыбраннойМетки.ИспользоватьНЕ;
			
		КонецЕсли;
		
	КонецЦикла;
	
	ЗначениеВРеквизитФормы(Дерево, "ДеревоЭлементовОтбора");
	
	ДобавлятьНулевоеЗначение = Результат.ВключаяНезаполненные;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоискПриИзменении(Элемент)
	
	ПоискПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПоискПриИзмененииНаСервере()
	
	НомерРезультатаПоиска = 0;
	УстановитьТекущуюСтрокуПоРезультатуПоиска();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьТекущуюСтрокуПоРезультатуПоиска()
	
	//Дерево = РеквизитФормыВЗначение("ДеревоЭлементовОтбора");
	//
	//НайденныеСтроки = Новый Массив;
	//
	//НайтиСтрокиПоОписаниюРекурсивно(Дерево.Строки, НайденныеСтроки);
	НайденныеСтроки = Новый Массив;
	НайтиСтрокиПоОписаниюРекурсивно(ДеревоЭлементовОтбора.ПолучитьЭлементы(), НайденныеСтроки);
	
	Если НайденныеСтроки.Количество() > 0 Тогда
	
		Если НайденныеСтроки.Количество() - 1 < НомерРезультатаПоиска Тогда
			НомерРезультатаПоиска = 0;
		КонецЕсли;
		
		Элементы.ДеревоЭлементовОтбора.ТекущаяСтрока = НайденныеСтроки[НомерРезультатаПоиска].ПолучитьИдентификатор();
		
		ТекущийЭлемент = Элементы.ДеревоЭлементовОтбора;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура НайтиСтрокиПоОписаниюРекурсивно(СтрокиДерева, НайденныеСтроки)
	
	Для Каждого Строка Из СтрокиДерева Цикл
		
		Если СтрНайти(ВРег(Строка(Строка.Значение)), ВРег(Поиск)) > 0 Тогда
			
			НайденныеСтроки.Добавить(Строка);
			
		КонецЕсли;
		
		НайтиСтрокиПоОписаниюРекурсивно(Строка.ПолучитьЭлементы(), НайденныеСтроки)
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаНайти(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("НачатьПоиск", ЭтаФорма);
	ПоказатьВводСтроки(ОписаниеОповещения, Поиск);
	
КонецПроцедуры

&НаКлиенте
Процедура НачатьПоиск(Результат, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если Поиск = Результат Тогда
		
		Далее(Неопределено);
		
	Иначе
		
		Поиск = Результат;
		ПоискПриИзменении(Неопределено);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Далее(Команда)
	
	НомерРезультатаПоиска = НомерРезультатаПоиска + 1;
	УстановитьТекущуюСтрокуПоРезультатуПоиска();
	
	ТекущийЭлемент = Элементы.ДеревоЭлементовОтбора;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьВыбранныеМетки()
	
	ВыбранныеМетки.Очистить();
	
	ПолучитьВыбранныеМеткиРекурсивно(ДеревоЭлементовОтбора.ПолучитьЭлементы());
	
	ВыбранныеМетки.Сортировать(?(ГруппироватьПоУсловию, "ГруппаОтбора,Представление", "Представление"));
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьВыбранныеМеткиРекурсивно(СтрокиДерева)
	
	Для Каждого СтрокаДерева Из СтрокиДерева Цикл
		
		Значение = Неопределено;
		ГруппаОтбора = "";
		
		Если НЕ СтрокаДерева.Значение.ЭтоГруппа
		   И ЗначениеЗаполнено(СтрокаДерева.Значение) Тогда
			
			Если СтрокаДерева.ИспользоватьИ Тогда
				
				Значение = СтрокаДерева.Значение;
				ГруппаОтбора = "И";
				
			ИначеЕсли СтрокаДерева.ИспользоватьИЛИ Тогда
				
				Значение = СтрокаДерева.Значение;
				ГруппаОтбора = "ИЛИ";
				
			ИначеЕсли СтрокаДерева.ИспользоватьНЕ Тогда
				
				Значение = СтрокаДерева.Значение;
				ГруппаОтбора = "НЕ";
				
			КонецЕсли;
			
			Если НЕ Значение = Неопределено Тогда
				
				НоваяСтрока = ВыбранныеМетки.Добавить();
				НоваяСтрока.Значение = Значение;
				НоваяСтрока.ГруппаОтбора = ГруппаОтбора;
				НоваяСтрока.Представление = Метки_ВызовСервера_ат.ПолучитьПредставлениеМеткиРекурсивно(Значение);
				
			КонецЕсли;
			
		КонецЕсли;
		
		ПолучитьВыбранныеМеткиРекурсивно(СтрокаДерева.ПолучитьЭлементы());
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбранныеМеткиПриАктивизацииСтроки(Элемент)
	
	Если Элементы.ВыбранныеМетки.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Строка = Метки_Клиент_ат.ПолучитьИдентификаторСтроки(Элементы.ВыбранныеМетки.ТекущиеДанные.Значение, ДеревоЭлементовОтбора.ПолучитьЭлементы());
	
	Если НЕ Строка = Неопределено Тогда
		Элементы.ДеревоЭлементовОтбора.ТекущаяСтрока = Строка.ПолучитьИдентификатор();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбранныеМеткиПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбранныеМеткиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущаяГруппаОтбора = Элементы.ВыбранныеМетки.ТекущиеДанные.ГруппаОтбора;
	
	Если ТекущаяГруппаОтбора = "И" Тогда
		ГруппаОтбора = "ИЛИ";
	ИначеЕсли ТекущаяГруппаОтбора = "ИЛИ" Тогда
		ГруппаОтбора = "НЕ";
	ИначеЕсли ТекущаяГруппаОтбора = "НЕ" Тогда
		ГруппаОтбора = "И";
	КонецЕсли;
	
	ДанныеСтроки = Элементы.ДеревоЭлементовОтбора.ТекущиеДанные;
	
	ИмяКолонки = "Использовать" + ГруппаОтбора;
	
	ДанныеСтроки[ИмяКолонки] = НЕ ДанныеСтроки[ИмяКолонки];
	
	ПриИзмененииИспользования(ИмяКолонки, ДанныеСтроки);
	СнятьСоседниеПометки(ИмяКолонки, ДанныеСтроки);
	
	Элементы.ВыбранныеМетки.ТекущиеДанные.ГруппаОтбора = ГруппаОтбора;
	
	ВыбранныеМетки.Сортировать(?(ГруппироватьПоУсловию, "ГруппаОтбора,Представление", "Представление"));		
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппироватьПоУсловию(Команда)
	
	Пометка = НЕ Элементы.ГруппироватьПоУсловию.Пометка;
	Элементы.ГруппироватьПоУсловию.Пометка = Пометка;
	ГруппироватьПоУсловию = Пометка;
	ОбновитьВыбранныеМетки();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбранныеМеткиПередУдалением(Элемент, Отказ)
	
	ДанныеСтроки = Элементы.ДеревоЭлементовОтбора.ТекущиеДанные;
		
	ДанныеСтроки["ИспользоватьИ"] = Ложь;
	ДанныеСтроки["ИспользоватьИЛИ"] = Ложь;
	ДанныеСтроки["ИспользоватьНЕ"] = Ложь;
	
	ПриИзмененииИспользования("ИспользоватьИ", ДанныеСтроки);
	ПриИзмененииИспользования("ИспользоватьИЛИ", ДанныеСтроки);
	ПриИзмененииИспользования("ИспользоватьНЕ", ДанныеСтроки);
	
	СформироватьПредставлениеОтбора();
	
КонецПроцедуры
