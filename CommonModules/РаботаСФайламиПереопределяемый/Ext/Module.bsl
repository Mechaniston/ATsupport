﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Работа с файлами".
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Можно ли занять данный файл.
//
// Параметры:
//  ДанныеФайла  - Структура с данными файла.
//  СтрокаОшибки - строка, содержащая текст ошибки в случае невозможности занять.
//
// Возвращаемое значение:
//  Булево.
Функция ВозможноЗанятьФайл(ДанныеФайла, СтрокаОшибки = "") Экспорт 
	
	Возврат Истина;
	
КонецФункции

// Вызывается при создании файла
// Параметры
//  ДанныеФайла - СправочникСсылка.Файлы - ссылка на созданный файл
//    см. функцию РаботаСФайламиСлужебныйВызовСервера.ПолучитьДанныеФайла()
//
Процедура ПриСозданииФайла(ДанныеФайла) Экспорт
	
КонецПроцедуры

// Вызывается после копирования файла из исходного файла
// для заполнения таких реквизитов нового файла, которые не 
// предусмотрены в БСП и были добавлены к справочнику Файлы или 
// ВерсииФайлов в конфигурации.
//
// Параметры:
//  НовыйФайл - СправочникСcылка.Файлы - ссылка на новый файл, который надо заполнить
//  ИсходныйФайл - СправочникСcылка.Файлы - ссылка на исходный файл, откуда надо скопировать реквизиты
//
Процедура ЗаполнитьРеквизитыФайлаИзИсходногоФайла(НовыйФайл, ИсходныйФайл) Экспорт
	
КонецПроцедуры

// Вызывается при захвате файла
// Параметры
//  ДанныеФайла - структура, содержащая сведения о Файле
//    см. функцию РаботаСФайламиСлужебныйВызовСервера.ПолучитьДанныеФайла()
//  УникальныйИдентификатор - уникальный идентификатор формы
//
Процедура ПриЗахватеФайла(ДанныеФайла, УникальныйИдентификатор) Экспорт
	
КонецПроцедуры

// Вызывается при освобождении файла
// Параметры
//  ДанныеФайла - структура, содержащая сведения о Файле
//    см. функцию РаботаСФайламиСлужебныйВызовСервера.ПолучитьДанныеФайла()
//  УникальныйИдентификатор - уникальный идентификатор формы
//
Процедура ПриОсвобожденииФайла(ДанныеФайла, УникальныйИдентификатор) Экспорт
	
КонецПроцедуры
