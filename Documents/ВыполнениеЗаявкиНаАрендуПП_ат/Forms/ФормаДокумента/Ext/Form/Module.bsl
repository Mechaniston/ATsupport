﻿
&НаКлиенте
Процедура ПоставкиПоставкаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	//+ Grig 24.05.2016 закомментировал т.к. не работало и приводило к записи дампа.
	
	//// Вставить содержимое обработчика.
	//СтандартнаяОбработка = ложь;
	//Если Объект.ДокументОснование.Пустая() тогда
	//	сообщение = новый СообщениеПользователю;
	//	сообщение.Поле = "Объект.ДокументОснование";
	//	сообщение.Текст = "Поле документа основания должно быть заполнено!";
	//	сообщение.Сообщить();
	//	
	//Иначе
	//	
	//отбор = Новый Структура;
	//отбор.Вставить("ПометкаУдаления", Ложь);
	//отбор.Вставить("ПродуктДляАренды",Элемент.Родитель.ТекущиеДанные.ПродуктДляАренды);
	//
	//ПараметрыФормы = Новый Структура;
	//ПараметрыФормы.Вставить("РежимВыбора",Истина);
	//ПараметрыФормы.Вставить("ЗакрытьПриВыборе", Истина);
	//ПараметрыФормы.Вставить("Отбор",отбор);
	//
	//
	//Форма = ПолучитьФорму("Документ.ВыполнениеЗаявкиНаАрендуПП_ат.Форма.ФормаОтбора",ПараметрыФормы,Элемент);
	//// Форма.Элементы.Список.отображение = ОтображениеТаблицы.Список; 
	//// какого-то хрена в иерархии список пустой... 16.12.2014.
	//Форма.Открыть();
	
	////ОткрытьФорму("Документ.ВыполнениеЗаявкиНаАрендуПП_ат.Форма.ФормаОтбора",ПараметрыФормы,Элемент);
	//		
	//КонецЕсли;
	
	//- Grig 24.05.2016
	
КонецПроцедуры

&НаКлиенте
Процедура ПродуктНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	//СтандартнаяОбработка = ложь;
	//Если Объект.ДокументОснование.Пустая() тогда
	//	сообщение = новый СообщениеПользователю;
	//	сообщение.Поле = "Объект.ДокументОснование";
	//	сообщение.Текст = "Поле документа основания должно быть заполнено!";
	//	сообщение.Сообщить();
	//	
	//Иначе
	//	
	//	//ПараметрыФормы = Новый Структура;
	//	//ПараметрыФормы.Вставить("РежимВыбора",Истина);
	//	//ПараметрыФормы.Вставить("ЗакрытьПриВыборе", Истина);
	//	//ПараметрыФормы.Вставить("документ", Объект.ДокументОснование);
	//	//ОткрытьФорму("Документ.ВыполнениеЗаявкиНаАрендуПП_ат.Форма.ФормаВыбораПродукта", ПараметрыФормы, Элемент);
	//	
	//	///ОткрытьФорму("Справочник.Договоры_ат.Форма.ФормаСпискаИВыбора",ПараметрыФормы,Элемент);
	//	// стандартная форма не подходит, ибо в запросе списка присутствует сравнение двух справочников
	//	
	//КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДоговорНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = ложь;
	Если Объект.ДокументОснование.Пустая() тогда
		сообщение = новый СообщениеПользователю;
		сообщение.Поле = "Объект.ДокументОснование";
		сообщение.Текст = "Поле документа основания должно быть заполнено!";
		сообщение.Сообщить();
	ИначеЕсли Объект.Организация.Пустая() тогда
		сообщение = новый СообщениеПользователю;
		сообщение.Поле = "Объект.Организация";
		сообщение.Текст = "Поле ОРГАНИЗАЦИЯ должно быть заполнено!";
		сообщение.Сообщить();
		
		
	Иначе
		//отбор = Новый Структура;
		//отбор.Вставить("ТипДоговора", ВОЗРАТТипДоговораАПП());
		//отбор.Вставить("ВидДог", ВОЗРАТТипДоговораАПП());
		//отбор.Вставить("Владедец", Объект.Клиент);
		//отбор.Вставить("Родитель", Справочники.Договоры_ат.ПустаяСсылка());
		//отбор.Вставить("Родитель", NULL);
		
		отбор = Новый Структура;
		//отбор.Вставить("ТипДоговора", ВОЗРАТТипДоговораАПП());
		//отбор.Вставить("ТипДоговора", ПредопределенноеЗначение("Перечисление.ТипыДоговоров_ат.АрендаПрограммныхПродуктов"));
		отбор.Вставить("Организация", Объект.Организация);
		отбор.Вставить("Владелец", Объект.Клиент);
		//отбор.Вставить("Владедец", Объект.Клиент);
		//отбор.Вставить("Родитель", Справочники.Договоры_ат.ПустаяСсылка());
		//отбор.Вставить("Родитель", NULL);
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("РежимВыбора",Истина);
		ПараметрыФормы.Вставить("ЗакрытьПриВыборе", Истина);
		ПараметрыФормы.Вставить("Отбор", отбор);
		ПараметрыФормы.Вставить("ТипДоговора", ПредопределенноеЗначение("Перечисление.ТипыДоговоров_ат.АрендаПрограммныхПродуктов"));
		
		
		//ПараметрыФормы.Вставить("ВидДог", ПредопределенноеЗначение("Перечисление.ТипыДоговоров_ат.АрендаПрограммныхПродуктов"));
		//ПараметрыФормы.Вставить("Организация", Объект.Организация);
		//ПараметрыФормы.Вставить("Контрагент",  Объект.Клиент);
		//ПараметрыФормы.Вставить("Родитель", Справочники.Договоры_ат.ПустаяСсылка());
		//ПараметрыФормы.Вставить("Родитель", NULL);
		//ПараметрыФормы.Вставить("Отбор", отбор);
		//ПараметрыФормы.Вставить("Владелец", Объект.Клиент);
		
		
		//		форма = ПолучитьФорму("ОбщаяФорма.ФормаВыбораДоговораПоТипу_ат",ПараметрыФормы,Элемент);
		форма = ПолучитьФорму("Справочник.Договоры_ат.ФормаВыбора",ПараметрыФормы,Элемент);
		
		// Форма.Открыть();
		// ОткрытьФорму("Документ.ВыполнениеЗаявкиНаАрендуПП_ат.Форма.ФормаВыбораДоговора",ПараметрыФормы,Элемент);
		//форма = ПолучитьФорму("Справочник.Договоры_ат.ФормаВыбора",ПараметрыФормы,Элемент);
		////Форма.Список.Ссылка.Установить("ТипДоговора", ВОЗРАТТипДоговораАПП());
		//Форма.список.
		Форма.Открыть();
		
		
	КонецЕсли;
	
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	ОрганизацияПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
	Объект.Договор = Неопределено;
	Для каждого стр из Объект.Поставки цикл
		стр.Поставка = Неопределено;	
		
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ДоговорПриИзменении(Элемент)
	ДоговорПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ДоговорПриИзмененииНаСервере()
	Для каждого стр из Объект.Поставки цикл
		стр.Поставка = Неопределено;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ПриОткрытииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПриОткрытииНаСервере()
	
	СтатусЗаявки = Аренда_ат.ПолучитьПоследнийСтатусЗаявки(Объект.ДокументОснование);
	
	Если СтатусЗаявки = 	Перечисления.ТипыСтатусовЗаявокНаАренду_ат.ОжиданиеОплаты
		тогда
		КоманднаяПанель.ПодчиненныеЭлементы.Записать.Видимость = ложь;
		КоманднаяПанель.ПодчиненныеЭлементы.Провести.Видимость = Истина;
		КоманднаяПанель.ПодчиненныеЭлементы.ПровестиИЗакрыть.Видимость = Истина;
		КоманднаяПанель.ПодчиненныеЭлементы.ПровестиИЗакрыть.КнопкаПоУмолчанию = Истина;
		
		
	ИначеЕсли СтатусЗаявки = Перечисления.ТипыСтатусовЗаявокНаАренду_ат.НаРассмотрении
		или  	  СтатусЗаявки = Перечисления.ТипыСтатусовЗаявокНаАренду_ат.ВОбработке
		или       СтатусЗаявки = Перечисления.ТипыСтатусовЗаявокНаАренду_ат.НаТехническомСогласовании
		или 	  СтатусЗаявки = Перечисления.ТипыСтатусовЗаявокНаАренду_ат.НаФинансовомСогласовании
		тогда
		КоманднаяПанель.ПодчиненныеЭлементы.Записать.Видимость = Истина;
		КоманднаяПанель.ПодчиненныеЭлементы.Провести.Видимость = ложь;
		КоманднаяПанель.ПодчиненныеЭлементы.ПровестиИЗакрыть.Видимость = ложь;
		КоманднаяПанель.ПодчиненныеЭлементы.Записать.КнопкаПоУмолчанию = Истина;
	Иначе 
		
		КоманднаяПанель.ПодчиненныеЭлементы.Записать.Видимость = ложь;
		КоманднаяПанель.ПодчиненныеЭлементы.Провести.Видимость = ложь;
		КоманднаяПанель.ПодчиненныеЭлементы.ПровестиИЗакрыть.Видимость = ложь;
		КоманднаяПанель.ПодчиненныеЭлементы.Закрыть.КнопкаПоУмолчанию = Истина;
		
	КонецЕсли;
КонецПроцедуры

//&НаСервере
//Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
//	
//	//ЗаписьСтатуса = РегистрыСведений.СтатусыЗаявокНаАренду_ат.СоздатьНаборЗаписей();
//	//ЗаписьСтатуса.Отбор.Заявка.Установить(ЭтотОбъект.ДокументОснование);
//	//
//	//НаборСведений = ЗаписьСтатуса.Добавить();
//	//НаборСведений.Заявка = ЭтотОбъект.ДокументОснование;
//	//НаборСведений.Период = ТекущаяДата();
//	//
//	//Если РежимЗаписиДокумента = РежимЗаписиДокумента.Запись и ЭтотОбъект.ПометкаУдаления = ложь тогда
//	//	НаборСведений.Статус = Перечисления.ТипыСтатусовЗаявокНаАренду_ат.ВОбработке;
//	//ИначеЕсли РежимЗаписиДокумента = РежимЗаписиДокумента.Запись и ЭтотОбъект.ПометкаУдаления = Истина тогда
//	//	НаборСведений.Статус = Перечисления.ТипыСтатусовЗаявокНаАренду_ат.Отклонена;
//	//ИначеЕсли РежимЗаписиДокумента = РежимЗаписиДокумента.Проведение тогда 
//	//	НаборСведений.Статус = Перечисления.ТипыСтатусовЗаявокНаАренду_ат.ОжиданиеОплаты;
//	//КонецЕсли;	
//	//НаборСведений.Пользователь = Пользователи.ТекущийПользователь();
//	//НаборСведений.Регистратор = ЭтотОбъект;
//	//ЗаписьСтатуса.Записать(Истина);
//
//КонецПроцедуры
