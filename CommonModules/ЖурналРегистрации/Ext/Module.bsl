﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Базовая функциональность".
// Внутренние процедуры и функции для работы с журналом регистрации.
//  
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЙ ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Выполняет чтение событий журнала регистрации в соответствии с установленным отбором
//
// Параметры:
//  ПараметрыОтчета - Структура, содержит параметры для чтения событий журнала регистрации
//	АдресХранилища - Адрес временного хранилища, куда помещается итоговый результат
//
//	Журнал	- ТаблицаЗначений, содержащая записи журнала регистрации
//	ОтборЖурналаНаКлиенте - Структура, настройки отбора для чтения записей журнала регистрации
//	КоличествоСобытий - Число, ограничивает число считываемых событий журнала
//	УникальныйИдентификатор - УникальныйИдентификатор, уникальный идентификатор формы
//	МенеджерВладельца - менеджер объекта, в форме которого отображается журнал регистрации, 
//						необходим для обратного вызова функций оформления
//	ДобавлятьДополнительныеКолонки - Булево, определяет необходимость обратного вызова для добавления дополнительных колонок
// 
Процедура ПрочитатьСобытияЖурналаРегистрации(ПараметрыОтчета, АдресХранилища) Экспорт
	
	Журнал = ПараметрыОтчета.Журнал;
	ОтборЖурналаНаКлиенте = ПараметрыОтчета.ОтборЖурналаРегистрации;
	КоличествоСобытий = ПараметрыОтчета.КоличествоПоказываемыхСобытий;
	УникальныйИдентификатор = ПараметрыОтчета.УникальныйИдентификатор;
	МенеджерВладельца = ПараметрыОтчета.МенеджерВладельца;
	ДобавлятьДополнительныеКолонки = ПараметрыОтчета.ДобавлятьДополнительныеКолонки;
	
	// Подготовка Отбора
	Отбор = Новый Структура;
	Для Каждого ЭлементОтбора Из ОтборЖурналаНаКлиенте Цикл
		Отбор.Вставить(ЭлементОтбора.Ключ, ЭлементОтбора.Значение);
	КонецЦикла;
	ПреобразованиеОтбора(Отбор);
	
	// Выгрузка отбираемых событий
	СобытияЖурнала = Новый ТаблицаЗначений;
	ВыгрузитьЖурналРегистрации(СобытияЖурнала, Отбор, , , КоличествоСобытий);
	СобытияЖурнала.Колонки.Добавить("НомерРисунка", Новый ОписаниеТипов("Число"));
	СобытияЖурнала.Колонки.Добавить("АдресДанных",  Новый ОписаниеТипов("Строка"));
	Если ОбщегоНазначенияПовтИсп.ДоступноИспользованиеРазделенныхДанных() Тогда
		СобытияЖурнала.Колонки.Добавить("ПредставлениеРазделенияДанныхСеанса", Новый ОписаниеТипов("Строка"));
	КонецЕсли;
	
	ПравилаУстановкиРисунка = Неопределено;
	
	Если ДобавлятьДополнительныеКолонки Тогда
		// Добавление дополнительных колонок
		МенеджерВладельца.ДобавитьДополнительныеКолонкиСобытия(СобытияЖурнала);
	КонецЕсли;
	
	ПроверенныеПользователи = Новый Массив();
	ПсевдонимыСлужебныхПользователей = Новый Соответствие();
	
	Для Каждого СобытиеЖурнала Из СобытияЖурнала Цикл
		
		// Заполнение номеров картинок строк
		МенеджерВладельца.УстановитьНомерРисунка(СобытиеЖурнала);
		
		Если ДобавлятьДополнительныеКолонки Тогда
			// Заполнение дополнительных полей, определенных только у владельца
			МенеджерВладельца.ЗаполнитьДополнительныеКолонкиСобытия(СобытиеЖурнала);
		КонецЕсли;
		
		// Преобразование массива метаданных в список значений
		СписокПредставленийМетаданных = Новый СписокЗначений;
		Если ТипЗнч(СобытиеЖурнала.ПредставлениеМетаданных) = Тип("Массив") Тогда
			СписокПредставленийМетаданных.ЗагрузитьЗначения(СобытиеЖурнала.ПредставлениеМетаданных);
		Иначе
			СписокПредставленийМетаданных.Добавить(Строка(СобытиеЖурнала.ПредставлениеМетаданных));
		КонецЕсли;
		СобытиеЖурнала.ПредставлениеМетаданных = СписокПредставленийМетаданных;
		
		// Преобразование массива "ПредставлениеРазделенияДанныхСеанса" в список значений
		Если ОбщегоНазначенияПовтИсп.РазделениеВключено()
			И Не ОбщегоНазначенияПовтИсп.ДоступноИспользованиеРазделенныхДанных() Тогда
			ПредставлениеРазделенияДанныхСеанса = СобытиеЖурнала.ПредставлениеРазделенияДанныхСеанса;
			СписокРеквизитовРазделенияДанных = Новый СписокЗначений;
			СписокРеквизитовРазделенияДанных.ЗагрузитьЗначения(ПредставлениеРазделенияДанныхСеанса);
			СобытиеЖурнала.ПредставлениеРазделенияДанныхСеанса = СписокРеквизитовРазделенияДанных;
		КонецЕсли;
		
		// Обработка данных специальных событий
		Если СобытиеЖурнала.Событие = "_$Access$_.Access" Тогда
			УстановитьСтрокуАдресаДанных(СобытиеЖурнала);
			
			Если СобытиеЖурнала.Данные <> Неопределено Тогда
				СобытиеЖурнала.Данные = ?(СобытиеЖурнала.Данные.Данные = Неопределено, "", "...");
			КонецЕсли;
			
		ИначеЕсли СобытиеЖурнала.Событие = "_$Access$_.AccessDenied" Тогда
			УстановитьСтрокуАдресаДанных(СобытиеЖурнала);
			
			Если СобытиеЖурнала.Данные <> Неопределено Тогда
				Если СобытиеЖурнала.Данные.Свойство("Право") Тогда
					СобытиеЖурнала.Данные = НСтр("ru = 'Право:'") + " " + СобытиеЖурнала.Данные.Право;
				Иначе
					СобытиеЖурнала.Данные = НСтр("ru = 'Действие:'") + " " + СобытиеЖурнала.Данные.Действие + 
						?(СобытиеЖурнала.Данные.Данные = Неопределено, "", ", ...");
				КонецЕсли;
			КонецЕсли;
			
		ИначеЕсли СобытиеЖурнала.Событие = "_$Session$_.Authentication"
		      ИЛИ СобытиеЖурнала.Событие = "_$Session$_.AuthenticationError" Тогда
			УстановитьСтрокуАдресаДанных(СобытиеЖурнала);
			
			СобытиеЖурналаДанные = "";
			Если СобытиеЖурнала.Данные <> Неопределено Тогда
				Для каждого КлючИЗначение Из СобытиеЖурнала.Данные Цикл
					Если ЗначениеЗаполнено(СобытиеЖурналаДанные) Тогда
						СобытиеЖурналаДанные = СобытиеЖурналаДанные + ", ...";
						Прервать;
					КонецЕсли;
					СобытиеЖурналаДанные = КлючИЗначение.Ключ + ": " + КлючИЗначение.Значение;
				КонецЦикла;
			КонецЕсли;
			СобытиеЖурнала.Данные = СобытиеЖурналаДанные;
			
		ИначеЕсли СобытиеЖурнала.Событие = "_$User$_.Delete" Тогда
			УстановитьСтрокуАдресаДанных(СобытиеЖурнала);
			
			СобытиеЖурналаДанные = "";
			Если СобытиеЖурнала.Данные <> Неопределено Тогда
				Для каждого КлючИЗначение Из СобытиеЖурнала.Данные Цикл
					СобытиеЖурналаДанные = КлючИЗначение.Ключ + ": " + КлючИЗначение.Значение;
					Прервать;
				КонецЦикла;
			КонецЕсли;
			СобытиеЖурнала.Данные = СобытиеЖурналаДанные;
			
		ИначеЕсли СобытиеЖурнала.Событие = "_$User$_.New"
		      ИЛИ СобытиеЖурнала.Событие = "_$User$_.Update" Тогда
			УстановитьСтрокуАдресаДанных(СобытиеЖурнала);
			
			ИмяПользователяИБ = "";
			Если СобытиеЖурнала.Данные <> Неопределено Тогда
				СобытиеЖурнала.Данные.Свойство("Имя", ИмяПользователяИБ);
			КонецЕсли;
			СобытиеЖурнала.Данные = НСтр("ru = 'Имя:'") + " " + ИмяПользователяИБ + ", ...";
			
		КонецЕсли;
		
		УстановитьПривилегированныйРежим(Истина);
		// Уточнение имени пользователя
		Если СобытиеЖурнала.Пользователь = Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000") Тогда
			СобытиеЖурнала.ИмяПользователя = НСтр("ru = '<Неопределен>'");
			
		ИначеЕсли СобытиеЖурнала.ИмяПользователя = "" Тогда
			СобытиеЖурнала.ИмяПользователя = Пользователи.ПолноеИмяНеУказанногоПользователя();
			
		ИначеЕсли ПользователиИнформационнойБазы.НайтиПоУникальномуИдентификатору(СобытиеЖурнала.Пользователь) = Неопределено Тогда
			СобытиеЖурнала.ИмяПользователя = СобытиеЖурнала.ИмяПользователя + " " + НСтр("ru = '<Удален>'");
		КонецЕсли;
		
		Если ПроверенныеПользователи.Найти(СобытиеЖурнала.Пользователь) = Неопределено Тогда
			
			ПроверенныеПользователи.Добавить(СобытиеЖурнала.Пользователь);
			
			Если Пользователи.ЭтоНеразделенныйПользователь(СобытиеЖурнала.Пользователь) Тогда
				
				ПсевдонимСлужебногоПользователя = Пользователи.ПолноеИмяСлужебногоПользователя(СобытиеЖурнала.Пользователь);
				
				ПсевдонимыСлужебныхПользователей.Вставить(СобытиеЖурнала.Пользователь, ПсевдонимСлужебногоПользователя);
				СобытиеЖурнала.ИмяПользователя = ПсевдонимСлужебногоПользователя;
				
			КонецЕсли;
			
		Иначе
			
			ПсевдонимСлужебногоПользователя = ПсевдонимыСлужебныхПользователей.Получить(СобытиеЖурнала.Пользователь);
			Если ПсевдонимСлужебногоПользователя <> Неопределено Тогда
				СобытиеЖурнала.ИмяПользователя = ПсевдонимСлужебногоПользователя;
			КонецЕсли;
			
		КонецЕсли;
		
		// Преобразование идентификатора в имя для использования в дальнейшем при установке отборе 
		СобытиеЖурнала.Пользователь = ПользователиИнформационнойБазы.НайтиПоУникальномуИдентификатору(СобытиеЖурнала.Пользователь);
		УстановитьПривилегированныйРежим(Ложь);
		
	КонецЦикла;
	
	ПоместитьВоВременноеХранилище(Новый Структура("СобытияЖурнала", 
									СобытияЖурнала), АдресХранилища);
	
КонецПроцедуры

// Создает пользовательское представление отбора журнала регистрации
//
// Параметры:
//	ПредставлениеОтбора - Строка, строка, содержащая пользовательское представление отбора
//	ОтборЖурналаРегистрации - Структура, значения отбора журнала регистрации
//	ОтборЖурналаРегистрацииПоУмолчанию - Структура, значения отбора журнала регистрации по умолчанию 
//										(не включаются в пользовательское представления)
//
Процедура СформироватьПредставлениеОтбора(ПредставлениеОтбора, ОтборЖурналаРегистрации, 
	ОтборЖурналаРегистрацииПоУмолчанию = Неопределено) Экспорт

	ПредставлениеОтбора = "";
	// Интервал
	ДатаНачалаИнтервала    = Неопределено;
	ДатаОкончанияИнтервала = Неопределено;
	Если Не ОтборЖурналаРегистрации.Свойство("ДатаНачала", ДатаНачалаИнтервала) Или
		 ДатаНачалаИнтервала = Неопределено Тогда 
		ДатаНачалаИнтервала    = '00010101000000';
	КонецЕсли;
	Если Не ОтборЖурналаРегистрации.Свойство("ДатаОкончания", ДатаОкончанияИнтервала) Или
		 ДатаОкончанияИнтервала = Неопределено Тогда 
		ДатаОкончанияИнтервала = '00010101000000';
	КонецЕсли;
	Если Не (ДатаНачалаИнтервала = '00010101000000' И ДатаОкончанияИнтервала = '00010101000000') Тогда
		ПредставлениеОтбора = ПредставлениеПериода(ДатаНачалаИнтервала, ДатаОкончанияИнтервала);
	КонецЕсли;
	
	ДобавитьОграничениеВПредставлениеОтбора(ОтборЖурналаРегистрации, ПредставлениеОтбора, "Пользователь");
	ДобавитьОграничениеВПредставлениеОтбора(ОтборЖурналаРегистрации, ПредставлениеОтбора, 
		"Событие", ОтборЖурналаРегистрацииПоУмолчанию);
	ДобавитьОграничениеВПредставлениеОтбора(ОтборЖурналаРегистрации, ПредставлениеОтбора, 
		"ИмяПриложения", ОтборЖурналаРегистрацииПоУмолчанию);
	ДобавитьОграничениеВПредставлениеОтбора(ОтборЖурналаРегистрации, ПредставлениеОтбора, "Сеанс");
	ДобавитьОграничениеВПредставлениеОтбора(ОтборЖурналаРегистрации, ПредставлениеОтбора, "Уровень");
	
	// Остальные ограничения указываем просто по представлением, без указания значений ограничения
	Для Каждого ЭлементОтбора Из ОтборЖурналаРегистрации Цикл
		ИмяОграничения = ЭлементОтбора.Ключ;
		Если ВРег(ИмяОграничения) = ВРег("ДатаНачала") 
				Или ВРег(ИмяОграничения) = ВРег("ДатаОкончания") 
				Или ВРег(ИмяОграничения) = ВРег("Событие") 
				Или ВРег(ИмяОграничения) = ВРег("ИмяПриложения") 
				Или ВРег(ИмяОграничения) = ВРег("Пользователь")
				Или ВРег(ИмяОграничения) = ВРег("Сеанс")
				Или ВРег(ИмяОграничения) = ВРег("Уровень") Тогда
			Продолжить; // Интервал и особые ограничения уже выводили
		КонецЕсли;
		
		// Для некоторых ограничений меняем представление
		Если ВРег(ИмяОграничения) = ВРег("ИмяПриложения") Тогда
			ИмяОграничения = НСтр("ru = 'Приложение'");
			
		ИначеЕсли ВРег(ИмяОграничения) = ВРег("СтатусТранзакции") Тогда
			ИмяОграничения = НСтр("ru = 'Статус транзакции'");
			
		ИначеЕсли ВРег(ИмяОграничения) = ВРег("ПредставлениеДанных") Тогда
			ИмяОграничения = НСтр("ru = 'Представление данных'");
			
		ИначеЕсли ВРег(ИмяОграничения) = ВРег("РабочийСервер") Тогда
			ИмяОграничения = НСтр("ru = 'Рабочий сервер'");
			
		ИначеЕсли ВРег(ИмяОграничения) = ВРег("ОсновнойIPПорт") Тогда
			ИмяОграничения = НСтр("ru = 'Основной IP порт'");
			
		ИначеЕсли ВРег(ИмяОграничения) = ВРег("ВспомогательныйIPПорт") Тогда
			ИмяОграничения = НСтр("ru = 'Вспомогательный IP порт'");
			
		КонецЕсли;
		
		Если Не ПустаяСтрока(ПредставлениеОтбора) Тогда 
			ПредставлениеОтбора = ПредставлениеОтбора + "; ";
		КонецЕсли;
		ПредставлениеОтбора = ПредставлениеОтбора + ИмяОграничения;
	КонецЦикла;
	
	Если ПустаяСтрока(ПредставлениеОтбора) Тогда
		ПредставлениеОтбора = НСтр("ru = 'Не установлен'");
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Преобразование отбора.
//
// Отбор - отбор - передаваемый отбор.
//
Процедура ПреобразованиеОтбора(Отбор)
	
	Для Каждого ЭлементОтбора Из Отбор Цикл
		Если ТипЗнч(ЭлементОтбора.Значение) = Тип("СписокЗначений") Тогда
			ПреобразованиеЭлементаОтбора(Отбор, ЭлементОтбора);
		ИначеЕсли ВРег(ЭлементОтбора.Ключ) = ВРег("Транзакция") Тогда
			Если Найти(ЭлементОтбора.Значение, "(") = 0 Тогда
				Отбор.Вставить(ЭлементОтбора.Ключ, "(" + ЭлементОтбора.Значение);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Преобразование элемента отбора.
//
// Параметры:
//	Отбор - отбор - передаваемый отбор.
//	Отбор - Элемент отбора - - элемент передаваемого отбора.
//
Процедура ПреобразованиеЭлементаОтбора(Отбор, ЭлементОтбора)
	
	// Эта процедура вызывается, если элемент отбора является списком значений,
	// в отборе же должен быть массив значений. Преобразуем список в массив.
	НовоеЗначение = Новый Массив;
	
	Для Каждого ЗначениеИзСписка Из ЭлементОтбора.Значение Цикл
		Если ВРег(ЭлементОтбора.Ключ) = ВРег("Уровень") Тогда
			// Уровни сообщений представлены строкой, требуется преобразование в значение перечисления
			НовоеЗначение.Добавить(Обработки.ЖурналРегистрации.УровеньЖурналаРегистрацииЗначениеПоИмени(ЗначениеИзСписка.Значение));
		ИначеЕсли ВРег(ЭлементОтбора.Ключ) = ВРег("СтатусТранзакции") Тогда
			// Статусы транзакций представлены строкой, требуется преобразование в значение перечисления
			НовоеЗначение.Добавить(Обработки.ЖурналРегистрации.СтатусТранзакцииЗаписиЖурналаРегистрацииЗначениеПоИмени(ЗначениеИзСписка.Значение));
		Иначе
			НовоеЗначение.Добавить(ЗначениеИзСписка.Значение);
		КонецЕсли;
	КонецЦикла;
	
	Отбор.Вставить(ЭлементОтбора.Ключ, НовоеЗначение);
	
КонецПроцедуры

// Добавить ограничение в представление отбора.
//	
// Параметры:
//	ОтборЖурналаРегистрации - Отбор - отбор журнала регистрации.
//	ПредставлениеОтбора - Строка - представление отбора.
//	ИмяОграничения - Строка - имя ограничения.
//	ОтборЖурналаРегистрацииПоУмолчанию - Отбор - отбор журнала регистрации по умолчанию.
//
Процедура ДобавитьОграничениеВПредставлениеОтбора(ОтборЖурналаРегистрации, ПредставлениеОтбора, ИмяОграничения,
	ОтборЖурналаРегистрацииПоУмолчанию = Неопределено)
	
	СписокОграничений = "";
	Ограничение = "";
	
	Если ОтборЖурналаРегистрации.Свойство(ИмяОграничения, СписокОграничений) Тогда
		
		// Не формируем представление отбора, если его значение соответствует значению отбора по умолчанию
		Если ОтборЖурналаРегистрацииПоУмолчанию <> Неопределено Тогда
			СписокОграниченийПоУмолчанию = "";
			Если ОтборЖурналаРегистрацииПоУмолчанию.Свойство(ИмяОграничения, СписокОграниченийПоУмолчанию) 
				И ОбщегоНазначенияКлиентСервер.СпискиЗначенийИдентичны(СписокОграниченийПоУмолчанию, СписокОграничений) Тогда
				Возврат;
			КонецЕсли;
		КонецЕсли;
		
		Если ИмяОграничения = "Событие" И СписокОграничений.Количество() > 5 Тогда
			
			Ограничение = ПредставлениеОтбора + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'События (%1)'"), СписокОграничений.Количество());
			
		ИначеЕсли ИмяОграничения = "Сеанс" И СписокОграничений.Количество() > 3 Тогда
			
			Ограничение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Сеансы (%1)'"), СписокОграничений.Количество());
			
		Иначе
			
			Для Каждого ЭлементСписка Из СписокОграничений Цикл
				
				Если Не ПустаяСтрока(Ограничение) Тогда
					Ограничение = Ограничение + ", ";
				КонецЕсли;
				
				Если (ВРег(ИмяОграничения) = ВРег("Сеанс")
				ИЛИ ВРег(ИмяОграничения) = ВРег("Уровень"))
				И ПустаяСтрока(Ограничение) Тогда
				
					Ограничение = НСтр("ru = '[ИмяОграничения]: [Значение]'");
					Ограничение = СтрЗаменить(Ограничение, "[Значение]", ЭлементСписка.Значение);
					Ограничение = СтрЗаменить(Ограничение, "[ИмяОграничения]", ИмяОграничения);
					
				ИначеЕсли ВРег(ИмяОграничения) = ВРег("Сеанс")
				ИЛИ ВРег(ИмяОграничения) = ВРег("Уровень")Тогда
					Ограничение = Ограничение + ЭлементСписка.Значение;
				Иначе
					Ограничение = Ограничение + ЭлементСписка.Представление;
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЕсли;
		
		Если Не ПустаяСтрока(ПредставлениеОтбора) Тогда 
			ПредставлениеОтбора = ПредставлениеОтбора + "; ";
		КонецЕсли;
		
		ПредставлениеОтбора = ПредставлениеОтбора + Ограничение;
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Вспомогательные процедуры и функции

// Только для внутреннего использования.
//
Процедура ПоместитьДанныеВоВременноеХранилище(СобытияЖурнала, УникальныйИдентификатор) Экспорт
	
	Для Каждого СтрокаСобытие Из СобытияЖурнала Цикл
		Если ПустаяСтрока(СтрокаСобытие.АдресДанных) Тогда
			АдресДанных = "";
		Иначе
			ЧтениеXML = Новый ЧтениеXML();
			ЧтениеXML.УстановитьСтроку(СтрокаСобытие.АдресДанных);
			АдресДанных = СериализаторXDTO.ПрочитатьXML(ЧтениеXML);
		КонецЕсли;
		СтрокаСобытие.АдресДанных = ПоместитьВоВременноеХранилище(АдресДанных, УникальныйИдентификатор);
	КонецЦикла;
	
КонецПроцедуры

// Только для внутреннего использования
//
Процедура УстановитьСтрокуАдресаДанных(СобытиеЖурнала)
	
	ЗаписьXML = Новый ЗаписьXML();
	ЗаписьXML.УстановитьСтроку();
	СериализаторXDTO.ЗаписатьXML(ЗаписьXML, СобытиеЖурнала.Данные); 
	СобытиеЖурнала.АдресДанных = ЗаписьXML.Закрыть();
	
КонецПроцедуры
