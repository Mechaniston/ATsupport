﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Префиксация объектов"
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Обработчик события "При получении номера на печать".
// Событие возникает перед стандартной обработкой получения номера.
// В обработчике можно переопределить стандартное поведение системы при формировании номера на печать.
//
// Параметры:
//  НомерОбъекта         - Строка - номер или код объекта, который обрабатывается
//  СтандартнаяОбработка – Булево – флаг стандартной обработки; если установить значение флага в Ложь,
//									то стандартная обработка формирования номера на печать выполняться не будет
// 
// Пример реализации кода обработчика:
// 
//	НомерОбъекта = ПрефиксацияОбъектовКлиентСервер.УдалитьПользовательскиеПрефиксыИзНомераОбъекта(НомерОбъекта);
//	СтандартнаяОбработка = Ложь;
// 
Процедура ПриПолученииНомераНаПечать(НомерОбъекта, СтандартнаяОбработка) Экспорт
	
	
КонецПроцедуры

// Получает номер документа для вывода на печать; из номера удаляются префиксы и лидирующие нули
// Функция:
// отбрасывает префикс организации,
// отбрасывает префикс информационной базы (опционально),
// отбрасывает пользовательские префиксы (опционально),
// удаляет лидирующие нули в номере объекта
//
Функция ПолучитьНомерНаПечать(Знач НомерОбъекта, УдалитьПрефиксИнформационнойБазы = Ложь, УдалитьПользовательскийПрефикс = Ложь, УдалитьПрефиксОрганизации = Ложь) Экспорт
	
	СтандартнаяОбработка = Истина;
	
	Если СтандартнаяОбработка = Ложь Тогда
		Возврат НомерОбъекта;
	КонецЕсли;
	
	// удаляем пользовательские префиксы из номера объекта
	Если УдалитьПользовательскийПрефикс Тогда
		НомерОбъекта = ПрефиксацияОбъектовКлиентСервер.УдалитьПользовательскиеПрефиксыИзНомераОбъекта(НомерОбъекта);
	КонецЕсли;
	
	// удаляем лидирующие нули из номера объекта
	НомерОбъекта = ПрефиксацияОбъектовКлиентСервер.УдалитьЛидирующиеНулиИзНомераОбъекта(НомерОбъекта);
	
	// удаляем префикс организации и префикс информационной базы из номера объекта
	НомерОбъекта = ПрефиксацияОбъектовКлиентСервер.УдалитьПрефиксыИзНомераОбъекта(НомерОбъекта, УдалитьПрефиксОрганизации, УдалитьПрефиксИнформационнойБазы);
	
	Возврат НомерОбъекта;
	
КонецФункции