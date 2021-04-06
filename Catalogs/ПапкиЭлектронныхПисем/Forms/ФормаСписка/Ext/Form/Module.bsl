﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Параметры.Отбор.Свойство("Владелец") Тогда
		
		Если НЕ Взаимодействия.ПользовательЯвляетсяОтветственнымЗаВедениеПапок(Параметры.Отбор.Владелец) Тогда
			
			ТолькоПросмотр = Истина;
			
		КонецЕсли;
		
	Иначе
		
		Отказ = Истина;
		
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "Владелец", Справочники.УчетныеЗаписиЭлектроннойПочты.ПустаяСсылка(),
		ВидСравненияКомпоновкиДанных.Равно, , Ложь);
	
КонецПроцедуры
