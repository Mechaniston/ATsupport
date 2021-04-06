﻿////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

////////////////////////////////////////////////////////////////////////////////
// Обработчики операций

// Соответствует операции DeliverMessages
Функция ДоставитьСообщения(КодОтправителя, ПотокХранилище)
	
	УстановитьПривилегированныйРежим(Истина);
	
	// Получаем ссылку на отправителя
	Отправитель = ПланыОбмена.ОбменСообщениями.НайтиПоКоду(КодОтправителя);
	
	Если Отправитель.Пустая() Тогда
		
		ВызватьИсключение НСтр("ru = 'Заданы неправильные настройки подключения к конечной точке.'");
		
	КонецЕсли;
	
	ЗагруженныеСообщения = Неопределено;
	ДанныеПрочитаныЧастично = Ложь;
	
	// Загружаем сообщения в информационную базу
	ОбменСообщениямиВнутренний.СериализоватьДанныеИзПотока(
		Отправитель,
		ПотокХранилище.Получить(),
		ЗагруженныеСообщения,
		ДанныеПрочитаныЧастично);
	
	// Обрабатываем очередь сообщений
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		
		ОбменСообщениямиВнутренний.ОбработатьОчередьСообщенийСистемы(ЗагруженныеСообщения);
		
	Иначе
		
		ПараметрыФоновогоЗадания = Новый Массив;
		ПараметрыФоновогоЗадания.Добавить(ЗагруженныеСообщения);
		
		ФоновыеЗадания.Выполнить("ОбменСообщениямиВнутренний.ОбработатьОчередьСообщенийСистемы", ПараметрыФоновогоЗадания);
		
	КонецЕсли;
	
	Если ДанныеПрочитаныЧастично Тогда
		
		ВызватьИсключение НСтр("ru = 'Произошла ошибка при доставке быстрых сообщений - некоторые сообщения
                                |не были доставлены из-за установленных блокировок областей данных!
                                |
                                |Эти сообщения будут обработаны в рамках очереди обработки сообщений системы.'");
		
	КонецЕсли;
	
КонецФункции

// Соответствует операции DeliverMessages
Функция ПолучитьПараметрыИнформационнойБазы(НаименованиеЭтойКонечнойТочки)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ПустаяСтрока(ОбменСообщениямиВнутренний.КодЭтогоУзла()) Тогда
		
		ЭтотУзелОбъект = ОбменСообщениямиВнутренний.ЭтотУзел().ПолучитьОбъект();
		ЭтотУзелОбъект.Код = Строка(Новый УникальныйИдентификатор());
		ЭтотУзелОбъект.Наименование = ?(ПустаяСтрока(НаименованиеЭтойКонечнойТочки),
									ОбменСообщениямиВнутренний.НаименованиеЭтогоУзлаПоУмолчанию(),
									НаименованиеЭтойКонечнойТочки);
		ЭтотУзелОбъект.Записать();
		
	ИначеЕсли ПустаяСтрока(ОбменСообщениямиВнутренний.НаименованиеЭтогоУзла()) Тогда
		
		ЭтотУзелОбъект = ОбменСообщениямиВнутренний.ЭтотУзел().ПолучитьОбъект();
		ЭтотУзелОбъект.Наименование = ?(ПустаяСтрока(НаименованиеЭтойКонечнойТочки),
									ОбменСообщениямиВнутренний.НаименованиеЭтогоУзлаПоУмолчанию(),
									НаименованиеЭтойКонечнойТочки);
		ЭтотУзелОбъект.Записать();
		
	КонецЕсли;
	
	ПараметрыЭтойТочки = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ОбменСообщениямиВнутренний.ЭтотУзел(), "Код, Наименование");
	
	Результат = Новый Структура;
	Результат.Вставить("Код",          ПараметрыЭтойТочки.Код);
	Результат.Вставить("Наименование", ПараметрыЭтойТочки.Наименование);
	
	Возврат ЗначениеВСтрокуВнутр(Результат);
КонецФункции

// Соответствует операции ConnectEndPoint
Функция ПодключитьКонечнуюТочку(Код, Наименование, НастройкиПодключенияПолучателяСтрокой)
	
	Отказ = Ложь;
	
	ОбменСообщениямиВнутренний.ВыполнитьПодключениеКонечнойТочкиНаСторонеПолучателя(Отказ, Код, Наименование, ЗначениеИзСтрокиВнутр(НастройкиПодключенияПолучателяСтрокой));
	
	Возврат Не Отказ;
КонецФункции

// Соответствует операции UpdateConnectionSettings
Функция ОбновитьНастройкиПодключения(Код, НастройкиПодключенияСтрокой)
	
	НастройкиПодключения = ЗначениеИзСтрокиВнутр(НастройкиПодключенияСтрокой);
	
	УстановитьПривилегированныйРежим(Истина);
	
	КонечнаяТочка = ПланыОбмена.ОбменСообщениями.НайтиПоКоду(Код);
	Если КонечнаяТочка.Пустая() Тогда
		ВызватьИсключение НСтр("ru = 'Заданы неправильные настройки подключения к конечной точке.'");
	КонецЕсли;
	
	НачатьТранзакцию();
	Попытка
		
		//обновляем настройки подключения
		СтруктураЗаписи = Новый Структура;
		СтруктураЗаписи.Вставить("Узел", КонечнаяТочка);
		СтруктураЗаписи.Вставить("ВидТранспортаСообщенийОбменаПоУмолчанию", Перечисления.ВидыТранспортаСообщенийОбмена.WS);
		
		СтруктураЗаписи.Вставить("WSURLВебСервиса",   НастройкиПодключения.WSURLВебСервиса);
		СтруктураЗаписи.Вставить("WSИмяПользователя", НастройкиПодключения.WSИмяПользователя);
		СтруктураЗаписи.Вставить("WSПароль",          НастройкиПодключения.WSПароль);
		СтруктураЗаписи.Вставить("WSЗапомнитьПароль", Истина);
		
		// добавляем запись в РС
		РегистрыСведений.НастройкиТранспортаОбмена.ОбновитьЗапись(СтруктураЗаписи);
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецФункции

// Соответствует операции SetLeadingEndPoint
Функция УстановитьВедущуюКонечнуюТочку(КодЭтойКонечнойТочки, КодВедущейКонечнойТочки)
	
	ОбменСообщениямиВнутренний.УстановитьВедущуюКонечнуюТочкуНаСторонеПолучателя(КодЭтойКонечнойТочки, КодВедущейКонечнойТочки);
	
КонецФункции

// Соответствует операции TestConnectionRecipient
Функция ПроверитьПодключениеНаСторонеПолучателя(НастройкиПодключенияСтрокой, КодОтправителя)
	
	УстановитьПривилегированныйРежим(Истина);
	
	СтрокаСообщенияОбОшибке = "";
	
	WSПрокси = ОбменСообщениямиВнутренний.ПолучитьWSПрокси(ЗначениеИзСтрокиВнутр(НастройкиПодключенияСтрокой), СтрокаСообщенияОбОшибке);
	
	Если WSПрокси = Неопределено Тогда
		ВызватьИсключение СтрокаСообщенияОбОшибке;
	КонецЕсли;
	
	WSПрокси.TestConnectionSender(КодОтправителя);
	
КонецФункции

// Соответствует операции TestConnectionSender
Функция ПроверитьПодключениеНаСторонеОтправителя(КодОтправителя)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ОбменСообщениямиВнутренний.КодЭтогоУзла() <> КодОтправителя Тогда
		
		ВызватьИсключение НСтр("ru = 'Настройки подключения базы получателя указывают на другого отправителя.'");
		
	КонецЕсли;
	
КонецФункции

