﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыЗапускаФоновогоЗадания = Неопределено;
	Если НЕ Параметры.Свойство("ПараметрыЗапускаФоновогоЗадания", ПараметрыЗапускаФоновогоЗадания) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если ПараметрыЗапускаФоновогоЗадания.Свойство("СопровождающийТекст") И ЗначениеЗаполнено(ПараметрыЗапускаФоновогоЗадания.СопровождающийТекст) Тогда
		СопровождающийТекст = ПараметрыЗапускаФоновогоЗадания.СопровождающийТекст;
	Иначе
		СопровождающийТекст = НСтр("ru = 'Команда выполняется...'");
	КонецЕсли;
	
	Если ПараметрыЗапускаФоновогоЗадания.Свойство("Заголовок") И ЗначениеЗаполнено(ПараметрыЗапускаФоновогоЗадания.Заголовок) Тогда
		Заголовок = ПараметрыЗапускаФоновогоЗадания.Заголовок;
	Иначе
		Заголовок = НСтр("ru = 'Пожалуйста, подождите'");
	КонецЕсли;
	
	Попытка
		
		ЗаданиеРезультат = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
			УникальныйИдентификатор,
			"ДополнительныеОтчетыИОбработки.ВыполнитьКоманду", 
			ПараметрыЗапускаФоновогоЗадания,
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Выполнение дополнительного отчета или обработки ""%1"", имя команды ""%2""'"),
				Строка(ПараметрыЗапускаФоновогоЗадания.ДополнительнаяОбработкаСсылка),
				ПараметрыЗапускаФоновогоЗадания.ИдентификаторКоманды));
		
		Выполнено = ЗаданиеРезультат.ЗаданиеВыполнено;
		ВызваноИсключение = Ложь;
		
		Если Выполнено Тогда
			Результат = ПолучитьИзВременногоХранилища(ЗаданиеРезультат.АдресХранилища);
		Иначе
			ФоновоеЗаданиеИдентификатор  = ЗаданиеРезультат.ИдентификаторЗадания;
			ФоновоеЗаданиеАдресХранилища = ЗаданиеРезультат.АдресХранилища;
		КонецЕсли;
		
	Исключение
		
		Выполнено = Ложь;
		ВызваноИсключение = Истина;
		ТекстОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Выполнено Тогда 
		Отказ = Истина;
		ОповеститьОВыборе(Результат);
	Иначе
		ИнтервалПроверки = 1;
		ФоновоеЗаданиеПроверитьПриЗакрытии = Истина;
		ПодключитьОбработчикОжидания("ПроверитьВыполнение", ИнтервалПроверки, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	Если ФоновоеЗаданиеПроверитьПриЗакрытии Тогда
		ФоновоеЗаданиеПроверитьПриЗакрытии = Ложь;
		РезультатПроверки = ПроверитьВыполнениеНаСервере(ФоновоеЗаданиеИдентификатор, ФоновоеЗаданиеАдресХранилища, Истина);
		Если РезультатПроверки.ЗаданиеВыполнено Тогда
			ОповеститьОВыборе(РезультатПроверки.Значение);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура Отменить(Команда)
	ТекстВопроса = НСтр("ru = 'Длительная операция еще выполняется.'");
	
	Кнопки = Новый СписокЗначений;
	Кнопки.Добавить(1, НСтр("ru = 'Продолжить'"));
	Кнопки.Добавить(КодВозвратаДиалога.Прервать);
	
	ОтключитьОбработчикОжидания("ПроверитьВыполнение");
	
	Ответ = Вопрос(ТекстВопроса, Кнопки, 60, 1);
	
	ПрерватьЕслиНеВыполнено = (Ответ = КодВозвратаДиалога.Прервать);
	
	РезультатПроверки = ПроверитьВыполнениеНаСервере(ФоновоеЗаданиеИдентификатор, ФоновоеЗаданиеАдресХранилища, ПрерватьЕслиНеВыполнено);
	
	Если РезультатПроверки.ЗаданиеВыполнено ИЛИ ПрерватьЕслиНеВыполнено Тогда
		ФоновоеЗаданиеПроверитьПриЗакрытии = Ложь;
		ОповеститьОВыборе(РезультатПроверки.Значение);
		Возврат;
	КонецЕсли;
	
	Если ИнтервалПроверки < 15 Тогда
		ИнтервалПроверки = ИнтервалПроверки + 0.7;
	КонецЕсли;
	
	ПодключитьОбработчикОжидания("ПроверитьВыполнение", ИнтервалПроверки, Истина);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура ПроверитьВыполнение()
	РезультатПроверки = ПроверитьВыполнениеНаСервере(ФоновоеЗаданиеИдентификатор, ФоновоеЗаданиеАдресХранилища, Ложь);
	
	Если РезультатПроверки.ЗаданиеВыполнено Тогда
		ФоновоеЗаданиеПроверитьПриЗакрытии = Ложь;
		ОповеститьОВыборе(РезультатПроверки.Значение);
	КонецЕсли;
	
	Если ИнтервалПроверки < 15 Тогда
		ИнтервалПроверки = ИнтервалПроверки + 0.7;
	КонецЕсли;
	ПодключитьОбработчикОжидания("ПроверитьВыполнение", ИнтервалПроверки, Истина);
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПроверитьВыполнениеНаСервере(ФоновоеЗаданиеИдентификатор, ФоновоеЗаданиеАдресХранилища, ПрерватьЕслиНеВыполнено)
	РезультатПроверки = Новый Структура("ЗаданиеВыполнено, Значение", Ложь, Неопределено);
	Если ДлительныеОперации.ЗаданиеВыполнено(ФоновоеЗаданиеИдентификатор) Тогда
		РезультатПроверки.ЗаданиеВыполнено = Истина;
		РезультатПроверки.Значение         = ПолучитьИзВременногоХранилища(ФоновоеЗаданиеАдресХранилища);
	ИначеЕсли ПрерватьЕслиНеВыполнено Тогда
		ДлительныеОперации.ОтменитьВыполнениеЗадания(ФоновоеЗаданиеИдентификатор);
	КонецЕсли;
	Возврат РезультатПроверки;
КонецФункции


