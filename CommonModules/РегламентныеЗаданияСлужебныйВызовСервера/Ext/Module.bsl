﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Регламентные задания".
// 
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// См. эту функцию в модуле РегламентныеЗаданияСлужебный.
Функция ПараметрыЗапускаОтдельногоСеансаВыполненияРегламентныхЗаданий(
			Знач ПоНастройкеАвтоОткрытия = Ложь) Экспорт
	
	Возврат РегламентныеЗаданияСлужебный
		.ПараметрыЗапускаОтдельногоСеансаВыполненияРегламентныхЗаданий(
			ПоНастройкеАвтоОткрытия);
	
КонецФункции

// См. эту функцию в модуле РегламентныеЗаданияСлужебный.
Функция НужноУведомлятьОНекорректномВыполненииРегламентныхЗаданий(ПериодУведомления) Экспорт
	
	Возврат РегламентныеЗаданияСлужебный
		.НужноУведомлятьОНекорректномВыполненииРегламентныхЗаданий(ПериодУведомления);
	
КонецФункции

// См. эту функцию в модуле РегламентныеЗаданияСлужебный.
Функция ТекущийСеансВыполняетРегламентныеЗадания(
			ЗаданияВыполняютсяНормально = Неопределено,
			Знач УстановитьТекущийСеансКакСеансВыполняющийРегламентныеЗадания = Ложь,
			ОписаниеОшибки = "") Экспорт
	
	Возврат РегламентныеЗаданияСлужебный.ТекущийСеансВыполняетРегламентныеЗадания(
			ЗаданияВыполняютсяНормально,
			УстановитьТекущийСеансКакСеансВыполняющийРегламентныеЗадания,
			ОписаниеОшибки);
	
КонецФункции

// См. эту процедуру в модуле РегламентныеЗаданияСлужебный.
Процедура ВыполнитьРегламентныеЗадания(ВремяВыполнения = 0) Экспорт
	
	РегламентныеЗаданияСлужебный.ВыполнитьРегламентныеЗадания(ВремяВыполнения);
	
КонецПроцедуры
