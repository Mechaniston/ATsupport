﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Отправка SMS"
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Отправляет SMS через веб-сервис МТС, возвращает идентификатор сообщения.
//
// Параметры:
//  НомераПолучателей - Массив - номера получателей в формате +7ХХХХХХХХХХ (строкой);
//  Текст             - Строка - текст сообщения, длиной не более 1000 символов;
//  ИмяОтправителя 	  - Строка - имя отправителя, которое будет отображаться вместо номера входящего SMS;
//  Логин             - Строка - логин пользователя услуги отправки sms;
//  Пароль            - Строка - пароль пользователя услуги отправки sms.
//
// Возвращаемое значение:
//  Структура: ОтправленныеСообщения - Массив структур: НомерОтправителя
//                                                  ИдентификаторСообщения
//             ОписаниеОшибки    - Строка - пользовательское представление ошибки, если пустая строка,
//                                          то ошибки нет.
Функция ОтправитьSMS(НомераПолучателей, Текст, ИмяОтправителя, Логин, Знач Пароль) Экспорт
	Результат = Новый Структура("ОтправленныеСообщения,ОписаниеОшибки", Новый Массив, "");
	
	Пароль = СтроковыеФункцииКлиентСервер.ВычислитьХешСтрокиПоАлгоритмуMD5(Пароль);
	
	ВебСервис = ПодключитьВебСервис();
	
	Для Каждого Элемент Из НомераПолучателей Цикл
		НомерПолучателя = ФорматироватьНомер(Элемент);
		Если Не ПустаяСтрока(НомерПолучателя) Тогда
			Попытка
				ИдентификаторСообщения = ВебСервис.SendMessage(НомерПолучателя, Лев(Текст, 1000), ИмяОтправителя, Логин, Пароль);
				Результат.ОтправленныеСообщения.Добавить(Новый Структура("НомерПолучателя,ИдентификаторСообщения",	
																  "+" +  НомерПолучателя, Формат(ИдентификаторСообщения, "ЧГ=")));
			Исключение
				ЗаписьЖурналаРегистрации(
					НСтр("ru = 'Отправка SMS'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
					УровеньЖурналаРегистрации.Ошибка,
					,
					,
					ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
				Результат.ОписаниеОшибки = Результат.ОписаниеОшибки 
										 + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'SMS на номер %1 не отправлено'"), Элемент)
										 + ": " + КраткоеПредставлениеОшибки(ИнформацияОбОшибке())
										 + Символы.ПС;
			КонецПопытки;
		КонецЕсли;
	КонецЦикла;
	
	Результат.ОписаниеОшибки = СокрП(Результат.ОписаниеОшибки);
	
	Возврат Результат;
КонецФункции

// Возвращает текстовое представление статуса доставки сообщения.
//
// Параметры:
//  ИдентификаторСообщения - Строка - идентификатор, присвоенный sms при отправке;
//  Логин                  - Строка - логин пользователя услуги отправки sms;
//  Пароль                 - Строка - пароль пользователя услуги отправки sms.
//
// Возвращаемое значение:
//  Строка - статус доставки. См. описание функции ОтправкаSMS.СтатусДоставки.
Функция СтатусДоставки(ИдентификаторСообщения, Логин, Знач Пароль) Экспорт
	Пароль = СтроковыеФункцииКлиентСервер.ВычислитьХешСтрокиПоАлгоритмуMD5(Пароль);
	ВебСервис = ПодключитьВебСервис();
	ArrayOfDeliveryInfo = ВебСервис.GetMessageStatus(ИдентификаторСообщения, Логин, Пароль);
	Для Каждого DeliveryInfo Из ArrayOfDeliveryInfo.DeliveryInfo Цикл
		Возврат СтатусДоставкиSMS(DeliveryInfo.DeliveryStatus);
	КонецЦикла;
	Возврат "Ошибка";
КонецФункции

Функция ФорматироватьНомер(Номер)
	Результат = "";
	ДопустимыеСимволы = "1234567890";
	Для Позиция = 1 По СтрДлина(Номер) Цикл
		Символ = Сред(Номер,Позиция,1);
		Если Найти(ДопустимыеСимволы, Символ) > 0 Тогда
			Результат = Результат + Символ;
		КонецЕсли;
	КонецЦикла;
	Возврат Результат;	
КонецФункции

Функция СтатусДоставкиSMS(СтатусСтрокой)
	СоответствиеСтатусов = Новый Соответствие;
	СоответствиеСтатусов.Вставить("Pending", "НеОтправлялось");
	СоответствиеСтатусов.Вставить("Sending", "Отправляется");
	СоответствиеСтатусов.Вставить("Sent", "Отправлено");
	СоответствиеСтатусов.Вставить("NotSent", "НеОтправлено");
	СоответствиеСтатусов.Вставить("Delivered", "Доставлено");
	СоответствиеСтатусов.Вставить("NotDelivered", "НеДоставлено");
	
	Результат = СоответствиеСтатусов[СтатусСтрокой];
	Возврат ?(Результат = Неопределено, "Ошибка", Результат);
КонецФункции

Функция ПодключитьВебСервис()
	Возврат WSСсылки.ОтправкаSMSЧерезМТС.СоздатьWSПрокси("http://mcommunicator.ru/M2M", "MTS_x0020_Communicator_x0020_M2M_x0020_XML_x0020_API", "MTS_x0020_Communicator_x0020_M2M_x0020_XML_x0020_APISoap12"); 
КонецФункции

