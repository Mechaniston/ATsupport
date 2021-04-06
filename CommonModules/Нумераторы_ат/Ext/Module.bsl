﻿
// Возвращает порядковый номер объекта.
//
// Параметры:
//  Объект - любой объект тип которого указан в ПВХ ОбъектыНумераторов_ат - Объект для которого будет получен номер.
//  Дата - Дата, Неопределено - Дата на которую будет получен номер. Если Неопределено - для объектов,
//	 имеющих дату, будет получена дата объекта, в противном случае будет использована ТекущаяДатаСеанса().
//  ОбъектНумератора - ПланВидовХарактеристикСсылка.ОбъектыНумераторов_ат - Нумератор который будет использован для получения номера.
//  ПериодичностьНомера - ПериодичностьНомераДокумента, ПериодичностьНомераБизнесПроцесса, ПеречислениеСсылка.ПериодичностиНумераторов_ат - Периодичность
//	 которая будет использована для получения номера.
//  ВозвращатьНомерСтрокой - Булево - Если Истина, то номер будет возвращен строкой с добавлением постфикса из ПВХ ОбъектыНумераторов_ат,
//	 иначе будет возвращена структура с ключами "Номер" и "Постфикс".
//
// Возвращаемое значение:
//   - Строка (если ВозвращатьНомерСтрокой = Истина), Структура (если ВозвращатьНомерСтрокой = Ложь), Неопределено (в случае ошибки)
//
Функция   ПолучитьНомерОбъекта(Объект, Дата = Неопределено, ОбъектНумератора = Неопределено,
	ПериодичностьНомера = Неопределено,	ВозвращатьНомерСтрокой = Истина) Экспорт
	
	Результат = ПолучитьПредварительныйНомерОбъекта(Объект, Дата, ОбъектНумератора, ПериодичностьНомера);
	
	Если ТипЗнч(Результат) = Тип("Структура") Тогда
		
		ЗаписатьНомерОбъекта(Результат);
		
		Если ВозвращатьНомерСтрокой Тогда
			Возврат Строка(Формат(Результат.Номер, "ЧГ=0")) + Результат.Постфикс;
		КонецЕсли;
		
	КонецЕсли;
			
	Возврат Результат;
		
КонецФункции

Функция   ПолучитьПредварительныйНомерОбъекта(Объект, Знач Дата = Неопределено, Знач ОбъектНумератора = Неопределено,
	Знач ПериодичностьНомера = Неопределено) Экспорт
	
	ОбъектНумератора = ОпределитьОбъектНумератора(Объект, ОбъектНумератора);
	
	Если ПериодичностьНомера = Неопределено Тогда
		ПериодичностьНомера = ПолучитьПериодичностьНомера(Объект, ОбъектНумератора);
	КонецЕсли;
	
	Если Дата = Неопределено Тогда
		Дата = ПолучитьДатуНомера(Объект);
	КонецЕсли;
	
	НачальнаяДатаПериода = ПолучитьНачальнуюДатуПериода(ПериодичностьНомера, Дата);
	
	НаборЗаписей = РегистрыСведений.Нумераторы_ат.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ОбъектНумератора.Установить(ОбъектНумератора);
	
	Если НачальнаяДатаПериода <> Неопределено Тогда
		НаборЗаписей.Отбор.НачальнаяДатаПериода.Установить(НачальнаяДатаПериода);
	КонецЕсли;
	
	НаборЗаписей.Прочитать();
	
	Если НаборЗаписей.Количество() > 0 Тогда
		Номер = НаборЗаписей[0].Номер;
	Иначе
		Номер = 0;
	КонецЕсли;
	
	Номер = Номер + 1;
	
	ВозвращаемаяСтруктура = Новый Структура;
	ВозвращаемаяСтруктура.Вставить("Номер", Номер);
	ВозвращаемаяСтруктура.Вставить("Постфикс", ОбъектНумератора.Постфикс);
	ВозвращаемаяСтруктура.Вставить("Объект", Объект);
	ВозвращаемаяСтруктура.Вставить("ОбъектНумератора", ОбъектНумератора);
	
	Если НачальнаяДатаПериода <> Неопределено Тогда
		ВозвращаемаяСтруктура.Вставить("НачальнаяДатаПериода", НачальнаяДатаПериода);
	КонецЕсли;
	
	Возврат ВозвращаемаяСтруктура;
	
КонецФункции

Функция   ЗаписатьНомерОбъекта(СтруктураНомера, ПолучатьНовыйНомерПриОшибке = Ложь) Экспорт
	
	КолвоПопыток = 0;
	
	Пока Истина Цикл
		
		Если ТипЗнч(СтруктураНомера) <> Тип("Структура") Тогда
			Возврат Неопределено;
		КонецЕсли;
	
		НаборЗаписей = РегистрыСведений.Нумераторы_ат.СоздатьНаборЗаписей();
		
		Если НЕ СтруктураНомера.Свойство("ОбъектНумератора") Тогда
			СтруктураНомера.ОбъектНумератора = ОпределитьОбъектНумератора(СтруктураНомера.Объект);
		КонецЕсли;
		
		НаборЗаписей.Отбор.ОбъектНумератора.Установить(СтруктураНомера.ОбъектНумератора);
		
		Если НЕ СтруктураНомера.Свойство("НачальнаяДатаПериода") ИЛИ НЕ ЗначениеЗаполнено(СтруктураНомера.НачальнаяДатаПериода) Тогда
			
			ПериодичностьНомера = ПолучитьПериодичностьНомера(СтруктураНомера.Объект, СтруктураНомера.ОбъектНумератора);
			Дата = ПолучитьДатуНомера(СтруктураНомера.Объект);
			НачальнаяДатаПериода = ПолучитьНачальнуюДатуПериода(ПериодичностьНомера, Дата);
			
		ИначеЕсли СтруктураНомера.Свойство("НачальнаяДатаПериода") Тогда
			
			НачальнаяДатаПериода = СтруктураНомера.НачальнаяДатаПериода;
			
		Иначе
			
			НачальнаяДатаПериода = Неопределено;
			
		КонецЕсли;
		
		Если НачальнаяДатаПериода <> Неопределено Тогда
			НаборЗаписей.Отбор.НачальнаяДатаПериода.Установить(НачальнаяДатаПериода);
		КонецЕсли;
		
		НаборЗаписей.Прочитать();
		
		Если НаборЗаписей.ВыгрузитьКолонку("Номер").Найти(СтруктураНомера.Номер) <> Неопределено Тогда // коллизия по номеру при записи
			
			КолвоПопыток = КолвоПопыток + 1;
			
			Если НЕ ПолучатьНовыйНомерПриОшибке ИЛИ КолвоПопыток > 5 Тогда
				
				Возврат Неопределено;
				
				//ВызватьИсключение "Ошибка нумератора - превышение количества попыток фиксации номера для объекта "
				//	+ Строка(СтруктураНомера.Объект);
				
			Иначе
				
				СтруктураНомера = ПолучитьПредварительныйНомерОбъекта(СтруктураНомера.Объект,
					НачальнаяДатаПериода, СтруктураНомера.ОбъектНумератора);
				
			КонецЕсли;
			
		Иначе
			
			НаборЗаписей.Очистить();
			
			Запись = НаборЗаписей.Добавить();
			
			Запись.ОбъектНумератора = СтруктураНомера.ОбъектНумератора;
			Запись.НачальнаяДатаПериода = НачальнаяДатаПериода;
			Запись.Номер = СтруктураНомера.Номер;
			
			Попытка
				
				НаборЗаписей.Записать();
				
			Исключение
				
				КолвоПопыток = КолвоПопыток + 1;//!!!!убрать дублирование блока
				
				Если НЕ ПолучатьНовыйНомерПриОшибке ИЛИ КолвоПопыток > 5 Тогда
					
					Возврат Неопределено;
					
					//ВызватьИсключение "Ошибка нумератора - превышение количества попыток фиксации номера для объекта "
					//	+ Строка(СтруктураНомера.Объект);
					
				Иначе
					
					СтруктураНомера = ПолучитьПредварительныйНомерОбъекта(СтруктураНомера.Объект,
						НачальнаяДатаПериода, СтруктураНомера.ОбъектНумератора);
					
				КонецЕсли;
				
			КонецПопытки;
			
			Возврат СтруктураНомера;
			
		КонецЕсли;
		
	КонецЦикла;
	
	////////////////////////////
	
	КолвоПопыток = 0;
	
	НачатьТранзакцию();
	
	Пока Истина Цикл
		
		Если ТипЗнч(СтруктураНомера) <> Тип("Структура") Тогда
			Возврат Неопределено;
		КонецЕсли;
		
		Попытка
			
			НаборЗаписей = РегистрыСведений.Нумераторы_ат.СоздатьНаборЗаписей();
			
			Если НЕ СтруктураНомера.Свойство("ОбъектНумератора") Тогда
				СтруктураНомера.ОбъектНумератора = ОпределитьОбъектНумератора(СтруктураНомера.Объект);
			КонецЕсли;
			
			НаборЗаписей.Отбор.ОбъектНумератора.Установить(СтруктураНомера.ОбъектНумератора);
			
			Если НЕ СтруктураНомера.Свойство("НачальнаяДатаПериода") ИЛИ НЕ ЗначениеЗаполнено(СтруктураНомера.НачальнаяДатаПериода) Тогда
				
				ПериодичностьНомера = ПолучитьПериодичностьНомера(СтруктураНомера.Объект, СтруктураНомера.ОбъектНумератора);
				Дата = ПолучитьДатуНомера(СтруктураНомера.Объект);
				НачальнаяДатаПериода = ПолучитьНачальнуюДатуПериода(ПериодичностьНомера, Дата);
				
			Иначе
				
				НачальнаяДатаПериода = Неопределено;
				
			КонецЕсли;
			
			Если НачальнаяДатаПериода <> Неопределено Тогда
				НаборЗаписей.Отбор.НачальнаяДатаПериода.Установить(НачальнаяДатаПериода);
			КонецЕсли;
			
			НаборЗаписей.Прочитать();
			
			Если НаборЗаписей.ВыгрузитьКолонку("Номер").Найти(СтруктураНомера.Номер) <> Неопределено Тогда
				ВызватьИсключение "Коллизия записи нового номера!";
			Иначе
				НаборЗаписей.Очистить();
			КонецЕсли;
			
			//Индекс = НаборЗаписей.Количество();
			//Пока Индекс > 0 Цикл
			//	
			//	Если НаборЗаписей[Индекс].Номер = СтруктураНомера.Номер Тогда
			//		
			//		
			//		
			//	КонецЕсли;
			//	
			//	НаборЗаписей.Удалить(Индекс);
			//	Индекс = Индекс - 1;
			//	
			//КонецЦикла;
			
				Запись = НаборЗаписей.Добавить();
				
				Запись.ОбъектНумератора = СтруктураНомера.ОбъектНумератора;
				Запись.НачальнаяДатаПериода = НачальнаяДатаПериода;
				//Запись.Номер = 1;
				
			//Иначе
			//	
			//	//Запись = НаборЗаписей[0];
			//	Запись = НаборЗаписей.Добавить();
			//	
			//КонецЕсли;
			
			Запись.Номер = СтруктураНомера.Номер;
			
			НаборЗаписей.Записать(Ложь);
			
			//// удалить все прочие записи
			//
			//НаборЗаписей = РегистрыСведений.Нумераторы_ат.СоздатьНаборЗаписей();
			//
			//
			//Если НачальнаяДатаПериода <> Неопределено Тогда
			//	
			//КонецЕсли;
			//
			//НаборЗаписей.Прочитать();
			//
			//Индекс = НаборЗаписей.Количество();
			//Пока Индекс > 0 Цикл
			//	
			//	Если НаборЗаписей[Индекс].Номер <> СтруктураНомера.Номер Тогда
			//		
			//		
			//		
			//	КонецЕсли;
			//	
			//КонецЦикла;
			//
			//НаборЗаписей.Записать();
			
			//
			
			ЗафиксироватьТранзакцию();
			
			Возврат СтруктураНомера;
			
		Исключение
			
			ОтменитьТранзакцию();
			
			КолвоПопыток = КолвоПопыток + 1;
			
			Если КолвоПопыток > 5 Тогда // и такого быть не должно..
				ВызватьИсключение "Ошибка нумератора - превышение количества попыток фиксации номера для объекта "
					+ СтруктураНомера.Объект;
			КонецЕсли;
			
			Если ПолучатьНовыйНомерПриОшибке Тогда
				
				СтруктураНомера = ПолучитьПредварительныйНомерОбъекта(СтруктураНомера.Объект,
					НачальнаяДатаПериода, СтруктураНомера.ОбъектНумератора);
				
			Иначе
				
				Возврат Неопределено;
				
			КонецЕсли;
			
		КонецПопытки;
		
	КонецЦикла;
	
КонецФункции
	
Функция   ПолучитьНачальнуюДатуПериода(ПериодичностьНомера, Дата)
	
	Если ПериодичностьНомера = Метаданные.СвойстваОбъектов.ПериодичностьНомераДокумента.Год
		ИЛИ ПериодичностьНомера = Метаданные.СвойстваОбъектов.ПериодичностьНомераБизнесПроцесса.Год
		ИЛИ ПериодичностьНомера = Перечисления.ПериодичностиНумераторов_ат.Год
		Тогда
		
		НачальнаяДатаПериодаОбъекта = НачалоГода(Дата);
		
	ИначеЕсли ПериодичностьНомера = Метаданные.СвойстваОбъектов.ПериодичностьНомераДокумента.Квартал
		ИЛИ ПериодичностьНомера = Метаданные.СвойстваОбъектов.ПериодичностьНомераБизнесПроцесса.Квартал
		ИЛИ ПериодичностьНомера = Перечисления.ПериодичностиНумераторов_ат.Квартал
		Тогда
		
		НачальнаяДатаПериодаОбъекта = НачалоКвартала(Дата);
		
	ИначеЕсли ПериодичностьНомера = Метаданные.СвойстваОбъектов.ПериодичностьНомераДокумента.Месяц
		ИЛИ ПериодичностьНомера = Метаданные.СвойстваОбъектов.ПериодичностьНомераБизнесПроцесса.Месяц
		ИЛИ ПериодичностьНомера = Перечисления.ПериодичностиНумераторов_ат.Месяц
		Тогда
		
		НачальнаяДатаПериодаОбъекта = НачалоМесяца(Дата);
		
	ИначеЕсли ПериодичностьНомера = Метаданные.СвойстваОбъектов.ПериодичностьНомераДокумента.День
		ИЛИ ПериодичностьНомера = Метаданные.СвойстваОбъектов.ПериодичностьНомераБизнесПроцесса.День
		ИЛИ ПериодичностьНомера = Перечисления.ПериодичностиНумераторов_ат.День
		Тогда
		
		НачальнаяДатаПериодаОбъекта = НачалоДня(Дата);
		
	Иначе
		
		НачальнаяДатаПериодаОбъекта = Неопределено;
		
	КонецЕсли;
	
	Возврат НачальнаяДатаПериодаОбъекта;
	
КонецФункции 

Функция   ОпределитьОбъектНумератора(Объект, Знач ОбъектНумератора = Неопределено)
	
	Если ОбъектНумератора = Неопределено Тогда
		
		ВХ = ПланыВидовХарактеристик.ОбъектыНумераторов_ат.Выбрать();
		
		Пока ВХ.Следующий() Цикл
			
			Если ВХ.ТипЗначения.СодержитТип(ТипЗнч(Объект.Ссылка)) Тогда
				
				ОпределенныйОбъектНумератора = ВХ.Ссылка;
				Прервать;
				
			КонецЕсли;
			
		КонецЦикла;
		
	ИначеЕсли ТипЗнч(ОбъектНумератора) = Тип("ТаблицаЗначений") Тогда 
		
		Для Каждого Строка Из ОбъектНумератора Цикл
			
			Если Строка.ОбъектНумератора.ТипЗначения.СодержитТип(ТипЗнч(Объект.Ссылка)) Тогда
				
				ОпределенныйОбъектНумератора = Строка.ОбъектНумератора;
				Прервать;
				
			КонецЕсли;
			
		КонецЦикла;
		
	Иначе
		
		ОпределенныйОбъектНумератора = ОбъектНумератора;
		
	КонецЕсли;
	
	Если ТипЗнч(ОпределенныйОбъектНумератора) <> Тип("ПланВидовХарактеристикСсылка.ОбъектыНумераторов_ат")
		ИЛИ ОбщегоНазначения_КлиентСервер_ат.ПустоеЗначение(ОпределенныйОбъектНумератора) Тогда
		
		ВызватьИсключение("Ошибка нумератора - не найден вид характеристики объектов нумератора с типом соответствующим объекту "
			+ СокрЛП(Строка(Объект)) + " (" + ТипЗнч(Объект) + ")");
		
	КонецЕсли;
	
	Возврат ОпределенныйОбъектНумератора;
	
КонецФункции

Функция   ПолучитьПериодичностьНомера(Объект, ОбъектНумератора)
	
	МетаданныеОбъекта = Объект.Метаданные();
	
	Если Метаданные.Документы.Содержит(МетаданныеОбъекта) ИЛИ Метаданные.БизнесПроцессы.Содержит(МетаданныеОбъекта) Тогда
		Возврат МетаданныеОбъекта.ПериодичностьНомера;
	Иначе
		Возврат ОбъектНумератора.Периодичность;
	КонецЕсли;
	
КонецФункции

Функция   ПолучитьДатуНомера(Объект)
	
	МетаданныеОбъекта = Объект.Метаданные();
	
	Если Метаданные.Документы.Содержит(МетаданныеОбъекта)
	 ИЛИ Метаданные.БизнесПроцессы.Содержит(МетаданныеОбъекта)
	 ИЛИ Метаданные.Задачи.Содержит(МетаданныеОбъекта) Тогда
		Возврат Объект.Дата;
	Иначе
		Возврат ТекущаяДатаСеанса();
	КонецЕсли;
	
КонецФункции
