﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Процедура добавляет запись в регистр по переданным значениям структуры
Процедура ДобавитьЗапись(СтруктураЗаписи) Экспорт
	
	ОбменДаннымиСервер.ДобавитьЗаписьВРегистрСведений(СтруктураЗаписи, "СостоянияУспешныхОбменовДаннымиОбластейДанных");
	
КонецПроцедуры

#КонецЕсли