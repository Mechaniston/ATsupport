﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда


Процедура ПриЗаписи(Отказ)
	
	ОбщегоНазначения.УстановитьЗначенияДополнительныхКонстант(Значение, Метаданные().Имя, ЭтотОбъект);
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Значение = Истина Тогда
		
		ОбменДаннымиСервер.ПриВключенииСинхронизацииДанных(Отказ);
		
	ИначеЕсли Значение = Ложь Тогда
		
		ОбменДаннымиСервер.ПриОтключенииСинхронизацииДанных(Отказ);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецЕсли