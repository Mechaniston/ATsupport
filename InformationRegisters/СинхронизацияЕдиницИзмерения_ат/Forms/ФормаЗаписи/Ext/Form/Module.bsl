﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИБ = Константы.БухгалтерияДляСинхронизации_ат.Получить();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НавигационнаяСсылкаПриИзменении(Элемент)
	
	Запись.Идентификатор = Неопределено;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Синхронизировать(Команда)
	
	Если НЕ ОбязательныеРеквизитыЗаполнены() Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Запись.НавигационнаяСсылка) Тогда
		
		РезультатСинхронизации = Синхронизировать_Сервер();
		Если ТипЗнч(РезультатСинхронизации) = Тип("Строка") Тогда
			ПоказатьПредупреждение(, РезультатСинхронизации, 5);
		КонецЕсли;
		
	Иначе
		
		ПоказатьПредупреждение(, "Навигационная ссылка не заполнена!", 5);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция   ОбязательныеРеквизитыЗаполнены()
	
	ТекстПредупреждения = "";
	
	Если Запись.Ссылка.Пустая() Тогда
		ТекстПредупреждения = "Единица измерения должна быть выбрана!";
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(ТекстПредупреждения) Тогда
		ПоказатьПредупреждение(, СокрЛ(ТекстПредупреждения));
	КонецЕсли;
	
	Возврат ТекстПредупреждения = "";
	
КонецФункции

&НаСервере
Функция   Синхронизировать_Сервер()
	
	Подключение = ПодключениеКИБ_ат.УстановитьПодключение(ИБ);
	Если ТипЗнч(Подключение) = Тип("Строка") Тогда
		Возврат Подключение;
	КонецЕсли;
	
	СинхронизированныйВидНоменклатуры = ПодключениеКИБ_ат.ПолучитьВнешнююСсылкуПоНавигационнойСсылке(Подключение, Запись.НавигационнаяСсылка);
	Если СинхронизированныйВидНоменклатуры = Неопределено Тогда
		Возврат "Введённая навигационная ссылка не корректна для выбранной ИБ Бухгалтерии Предприятия <" + ИБ + ">!";
	КонецЕсли;
	
	Запись.Идентификатор = Строки_КлиентСервер_ат.ПолучитьСтрУИдПоНавСсылке(Запись.НавигационнаяСсылка);
	
	Модифицированность = Истина;
	
	Возврат "Синхронизация прошла успешно";
	
КонецФункции

#КонецОбласти
