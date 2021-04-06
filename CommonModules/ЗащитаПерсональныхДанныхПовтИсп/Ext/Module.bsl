﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Защита персональных данных"
// Служебные процедуры и функции подсистемы.
//  
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Функция определяет перечень событий журнала регистрации 
//  в соответствии с требованиями 152-ФЗ
//
Функция СписокКонтролируемыхСобытий152ФЗ() Экспорт
	
	СписокСобытий = Новый СписокЗначений;
	СписокСобытий.Добавить("_$Access$_.Access",					НСтр("ru = 'Доступ. Доступ'"));
	СписокСобытий.Добавить("_$Access$_.AccessDenied",			НСтр("ru = 'Доступ. Отказ в доступе'"));
	СписокСобытий.Добавить("_$Session$_.Authentication",		НСтр("ru = 'Сеанс. Аутентификация'"));
	СписокСобытий.Добавить("_$Session$_.AuthenticationError",	НСтр("ru = 'Сеанс. Ошибка аутентификации'"));
	СписокСобытий.Добавить("_$Session$_.Start",					НСтр("ru = 'Сеанс. Начало'"));
	СписокСобытий.Добавить("_$Session$_.Finish",				НСтр("ru = 'Сеанс. Завершение'"));
	
	Возврат СписокСобытий;
	
КонецФункции

// Функция формирует структуру, необходимую для установки индекса картинки 
// в таблице событий журнала регистрации
//
Функция НомераКартинокСобытий152ФЗ() Экспорт
	
	НомераКартинок = Новый Соответствие;
	НомераКартинок.Вставить("_$Session$_.Authentication",		1);
	НомераКартинок.Вставить("_$Session$_.AuthenticationError",	2);
	НомераКартинок.Вставить("_$Session$_.Start",				3);
	НомераКартинок.Вставить("_$Session$_.Finish",				4);
	НомераКартинок.Вставить("_$Access$_.Access",				5);
	НомераКартинок.Вставить("_$Access$_.AccessDenied",			6);
	
	Возврат НомераКартинок;
	
КонецФункции

// Функция определяет перечень контролируемых приложений системы
//  в соответствии с требованиями 152-ФЗ
//
Функция СписокКонтролируемыхПриложений152ФЗ() Экспорт
	
	СписокПриложений = Новый Массив;
	СписокПриложений.Добавить("1CV8");				// - идентификатор приложения 1С:Предприятие в режиме запуска "Толстый клиент"; 
	СписокПриложений.Добавить("1CV8C");				// - идентификатор приложения 1С:Предприятие в режиме запуска "Тонкий клиент"; 
	СписокПриложений.Добавить("WebClient");			// - идентификатор приложения 1С:Предприятие в режиме запуска "Веб-клиент"; 
	СписокПриложений.Добавить("Designer");			// - идентификатор приложения Конфигуратор; 

	Возврат СписокПриложений;
	
КонецФункции