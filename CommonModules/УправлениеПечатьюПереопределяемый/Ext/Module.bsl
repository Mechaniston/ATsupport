﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Печать".
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Переопределяет таблицу возможных форматов для сохранения табличного документа.
// Вызывается из ОбщегоНазначения.НастройкиФорматовСохраненияТабличногоДокумента()
//
// Параметры
//  ТаблицаФорматов - ТаблицаЗначений:
//                     ТипФайлаТабличногоДокумента - ТипФайлаТабличногоДокумента                 - значение в платформе, соответствующее формату;
//                     Ссылка                      - ПеречислениеСсылка.ФорматыСохраненияОтчетов - ссылка на метаданные, где хранится представление;
//                     Представление               - Строка -                                    - представление типа файла (заполняется из перечисления);
//                     Расширение                  - Строка -                                    - тип файла для операционной системы;
//                     Картинка                    - Картинка                                    - значок формата.
//
Процедура ПриЗаполненииНастроекФорматовСохраненияТабличногоДокумента(ТаблицаФорматов) Экспорт
	
КонецПроцедуры

// Переопределяет список команд печати, получаемый функцией 
Процедура ПередДобавлениемКомандПечати(ИмяФормы, КомандыПечати, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры


