﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УправляемыеФормы_Сервер_ат.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	Элементы.ФормаНастройкаДоступаКМеткам.Видимость = ВнутреннегоИспользования_ВызовСервера_ат.СотрудникОрганизации();
	
	УстановитьОтборПоГруппамМетокКлиента();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УправляемыеФормы_Клиент_ат.ПриОткрытии(ЭтаФорма, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриПовторномОткрытии()
	
	УправляемыеФормы_Клиент_ат.ПриПовторномОткрытии(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	УправляемыеФормы_Клиент_ат.ПередЗакрытием(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	УправляемыеФормы_Клиент_ат.ПриЗакрытии(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	УправляемыеФормы_Клиент_ат.ОбработкаВыбора(ЭтаФорма, ВыбранноеЗначение, ИсточникВыбора);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	УправляемыеФормы_Клиент_ат.ОбработкаОповещения(ЭтаФорма, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	УправляемыеФормы_Сервер_ат.ОбработкаПроверкиЗаполненияНаСервере(ЭтаФорма, Отказ, ПроверяемыеРеквизиты);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокОкончаниеПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	
	Оповестить("ОбновленСписокМеток");
	
КонецПроцедуры

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
Процедура УстановитьОтборПоГруппамМетокКлиента()
	
	Если НЕ ВнутреннегоИспользования_КлиентСерверПовтИсп_ат.СотрудникОрганизации() Тогда
		
		//Список.Параметры.УстановитьЗначениеПараметра("ГруппыМетокПользователя", Новый Массив(ПараметрыСеанса.ГруппыМетокПользователя_ат));
		
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура НастройкаДоступаКМеткам(Команда)
	
	ОткрытьФорму("РегистрСведений.ДоступностьМетокКлиентам_ат.ФормаСписка",, ЭтаФорма);
	
КонецПроцедуры


&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("ИзменитьДоступностьОсновныхКомандФормы", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьДоступностьОсновныхКомандФормы()
	
	Метка = Элементы.Список.ТекущаяСтрока;
	Элементы.ГруппаОсновныеКомандыФормы.Доступность = ПолучитьВозможностьРедактированияМетки(Метка);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьВозможностьРедактированияМетки(Метка)
		
	Возврат Метки_Сервер_ат.ПроверитьДоступностьМетки(Метка, Истина);
	
КонецФункции

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если НЕ Метки_Сервер_ат.ПроверитьДоступностьМетки(Элементы.Список.ТекущаяСтрока, Истина) Тогда
		
		Отказ = Истина;
		ПоказатьПредупреждение(, "Редактирование меток в этой группе ограничено", 5);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередУдалением(Элемент, Отказ)
	
	Если НЕ Метки_Сервер_ат.ПроверитьДоступностьМетки(Элементы.Список.ТекущаяСтрока, Истина) Тогда
		
		Отказ = Истина;
		ПоказатьПредупреждение(, "Редактирование меток в этой группе ограничено", 5);
		
	КонецЕсли;
	
КонецПроцедуры
