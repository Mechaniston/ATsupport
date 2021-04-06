﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Функция АбсолютныйКаталогОбменаИнформацией(Знач Корреспондент) Экспорт
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	НастройкиТранспортаОбменаОбластиДанных.FILEКаталогОбменаИнформацией КАК ОтносительныйКаталогОбменаИнформацией,
	|	ЕСТЬNULL(НастройкиТранспортаОбменаОбластейДанных.FILEКаталогОбменаИнформацией, """") КАК ОбщийКаталогОбменаИнформацией
	|ИЗ
	|	РегистрСведений.НастройкиТранспортаОбменаОбластиДанных КАК НастройкиТранспортаОбменаОбластиДанных
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкиТранспортаОбменаОбластейДанных КАК НастройкиТранспортаОбменаОбластейДанных
	|		ПО (НастройкиТранспортаОбменаОбластейДанных.КонечнаяТочкаКорреспондента = НастройкиТранспортаОбменаОбластиДанных.КонечнаяТочкаКорреспондента)
	|ГДЕ
	|	НастройкиТранспортаОбменаОбластиДанных.Корреспондент = &Корреспондент";
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Корреспондент", Корреспондент);
	Запрос.Текст = ТекстЗапроса;
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не заданы настройки подключения для корреспондента ""%1"".'"), Строка(Корреспондент));
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	
	ОбщийКаталогОбменаИнформацией = Выборка.ОбщийКаталогОбменаИнформацией;
	ОтносительныйКаталогОбменаИнформацией = Выборка.ОтносительныйКаталогОбменаИнформацией;
	
	Если ПустаяСтрока(ОбщийКаталогОбменаИнформацией)
		ИЛИ ПустаяСтрока(ОтносительныйКаталогОбменаИнформацией) Тогда
		
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не заданы настройки подключения для корреспондента ""%1"".'"), Строка(Корреспондент));
	КонецЕсли;
	
	Возврат ОбщегоНазначенияКлиентСервер.ПолучитьПолноеИмяФайла(ОбщийКаталогОбменаИнформацией, ОтносительныйКаталогОбменаИнформацией);
КонецФункции

Функция ВидТранспорта(Знач Корреспондент) Экспорт
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ЕСТЬNULL(НастройкиТранспортаОбменаОбластейДанных.ВидТранспортаСообщенийОбменаПоУмолчанию, НЕОПРЕДЕЛЕНО) КАК ВидТранспорта
	|ИЗ
	|	РегистрСведений.НастройкиТранспортаОбменаОбластиДанных КАК НастройкиТранспортаОбменаОбластиДанных
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкиТранспортаОбменаОбластейДанных КАК НастройкиТранспортаОбменаОбластейДанных
	|		ПО (НастройкиТранспортаОбменаОбластейДанных.КонечнаяТочкаКорреспондента = НастройкиТранспортаОбменаОбластиДанных.КонечнаяТочкаКорреспондента)
	|ГДЕ
	|	НастройкиТранспортаОбменаОбластиДанных.Корреспондент = &Корреспондент";
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Корреспондент", Корреспондент);
	Запрос.Текст = ТекстЗапроса;
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	
	Возврат Выборка.ВидТранспорта;
КонецФункции

Функция НастройкиТранспорта(Знач Корреспондент) Экспорт
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	"""" КАК FILEКаталогОбменаИнформацией,
	|	"""" КАК FTPСоединениеПуть,
	|
	|	НастройкиТранспортаОбменаОбластиДанных.FILEКаталогОбменаИнформацией КАК FILEОтносительныйКаталогОбменаИнформацией,
	|	НастройкиТранспортаОбменаОбластиДанных.FTPКаталогОбменаИнформацией  КАК FTPОтносительныйКаталогОбменаИнформацией,
	|
	|	НастройкиТранспортаОбменаОбластейДанных.FILEКаталогОбменаИнформацией КАК FILEОбщийКаталогОбменаИнформацией,
	|	НастройкиТранспортаОбменаОбластейДанных.FILEСжиматьФайлИсходящегоСообщения,
	|
	|	НастройкиТранспортаОбменаОбластейДанных.FTPСоединениеПуть КАК FTPОбщийКаталогОбменаИнформацией,
	|	НастройкиТранспортаОбменаОбластейДанных.FTPСжиматьФайлИсходящегоСообщения,
	|	НастройкиТранспортаОбменаОбластейДанных.FTPСоединениеМаксимальныйДопустимыйРазмерСообщения,
	|	НастройкиТранспортаОбменаОбластейДанных.FTPСоединениеПароль,
	|	НастройкиТранспортаОбменаОбластейДанных.FTPСоединениеПассивноеСоединение,
	|	НастройкиТранспортаОбменаОбластейДанных.FTPСоединениеПользователь,
	|	НастройкиТранспортаОбменаОбластейДанных.FTPСоединениеПорт,
	|
	|	НастройкиТранспортаОбменаОбластейДанных.ВидТранспортаСообщенийОбменаПоУмолчанию,
	|	НастройкиТранспортаОбменаОбластейДанных.КоличествоЭлементовВТранзакцииВыгрузкиДанных,
	|	НастройкиТранспортаОбменаОбластейДанных.КоличествоЭлементовВТранзакцииЗагрузкиДанных,
	|	НастройкиТранспортаОбменаОбластейДанных.ПарольАрхиваСообщенияОбмена,
	|	
	|	НастройкиТранспортаОбмена.WSURLВебСервиса,
	|	НастройкиТранспортаОбмена.WSИмяПользователя,
	|	НастройкиТранспортаОбмена.WSПароль
	|	
	|ИЗ
	|	РегистрСведений.НастройкиТранспортаОбменаОбластиДанных КАК НастройкиТранспортаОбменаОбластиДанных
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкиТранспортаОбменаОбластейДанных КАК НастройкиТранспортаОбменаОбластейДанных
	|		ПО (НастройкиТранспортаОбменаОбластейДанных.КонечнаяТочкаКорреспондента = НастройкиТранспортаОбменаОбластиДанных.КонечнаяТочкаКорреспондента)
	|		
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкиТранспортаОбмена КАК НастройкиТранспортаОбмена
	|		ПО (НастройкиТранспортаОбмена.Узел = НастройкиТранспортаОбменаОбластиДанных.КонечнаяТочкаКорреспондента)
	|ГДЕ
	|	НастройкиТранспортаОбменаОбластиДанных.Корреспондент = &Корреспондент";
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Корреспондент", Корреспондент);
	Запрос.Текст = ТекстЗапроса;
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Результат = ОбменДаннымиСервер.РезультатЗапросаВСтруктуру(РезультатЗапроса);
	
	Результат.FILEКаталогОбменаИнформацией = ОбщегоНазначенияКлиентСервер.ПолучитьПолноеИмяФайла(
		Результат.FILEОбщийКаталогОбменаИнформацией,
		Результат.FILEОтносительныйКаталогОбменаИнформацией);
	
	Результат.FTPСоединениеПуть = ОбщегоНазначенияКлиентСервер.ПолучитьПолноеИмяФайла(
		Результат.FTPОбщийКаталогОбменаИнформацией,
		Результат.FTPОтносительныйКаталогОбменаИнформацией);
	
	Результат.Вставить("ИспользоватьВременныйКаталогДляОтправкиИПриемаСообщений", Истина);
	
	ПараметрыFTP = ОбменДаннымиСервер.FTPИмяСервераИПуть(Результат.FTPСоединениеПуть);
	
	Результат.Вставить("FTPСервер", ПараметрыFTP.Сервер);
	Результат.Вставить("FTPПуть",   ПараметрыFTP.Путь);
	
	Возврат Результат;
КонецФункции

Функция НастройкиТранспортаWS(Знач Корреспондент) Экспорт
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	НастройкиТранспортаОбмена.WSURLВебСервиса,
	|	НастройкиТранспортаОбмена.WSИмяПользователя,
	|	НастройкиТранспортаОбмена.WSПароль
	|ИЗ
	|	РегистрСведений.НастройкиТранспортаОбменаОбластиДанных КАК НастройкиТранспортаОбменаОбластиДанных
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкиТранспортаОбмена КАК НастройкиТранспортаОбмена
	|		ПО (НастройкиТранспортаОбмена.Узел = НастройкиТранспортаОбменаОбластиДанных.КонечнаяТочкаКорреспондента)
	|ГДЕ
	|	НастройкиТранспортаОбменаОбластиДанных.Корреспондент = &Корреспондент";
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Корреспондент", Корреспондент);
	Запрос.Текст = ТекстЗапроса;
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не заданы настройки подключения веб-сервиса для корреспондента %1.'"),
			Строка(Корреспондент));
	КонецЕсли;
	
	Возврат ОбменДаннымиСервер.РезультатЗапросаВСтруктуру(РезультатЗапроса);
КонецФункции

//

// Процедура обновляет запись в регистре по переданным значениям структуры
//
Процедура ОбновитьЗапись(СтруктураЗаписи) Экспорт
	
	ОбменДаннымиСервер.ОбновитьЗаписьВРегистрСведений(СтруктураЗаписи, "НастройкиТранспортаОбменаОбластиДанных");
	
КонецПроцедуры

// Процедура добавляет запись в регистр по переданным значениям структуры
//
Процедура ДобавитьЗапись(СтруктураЗаписи) Экспорт
	
	ОбменДаннымиСервер.ДобавитьЗаписьВРегистрСведений(СтруктураЗаписи, "НастройкиТранспортаОбменаОбластиДанных");
	
КонецПроцедуры

#КонецЕсли
