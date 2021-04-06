﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	// Установка обязательных параметров
	ПараметрыДанных = Новый Структура;
	ПараметрыДанных.Вставить("Пользовательские", КомпоновщикНастроек.ПолучитьНастройки().ПараметрыДанных);
	ПараметрыДанных.Вставить("Текущие",          КомпоновщикНастроек.Настройки.ПараметрыДанных);
	
	УстановитьОбязательныйПараметр("Пользователи", "ЗаданныеПользователи", Ложь, Истина, ПараметрыДанных);
	УстановитьОбязательныйПараметр("Разделы",      "ЗаданныеРазделы",      Ложь, Истина, ПараметрыДанных);
	УстановитьОбязательныйПараметр("Объекты",      "ЗаданныеОбъекты",      Ложь, Истина, ПараметрыДанных);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура УстановитьОбязательныйПараметр(ИмяПараметра, ИмяОбязательногоПараметра, ЗначениеКогдаНеИспользуется, ЗначениеПриНеопределено, ПараметрыДанных)
	
	Параметр = ПараметрыДанных.Пользовательские.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных(ИмяПараметра));
	
	Если Параметр.Использование Тогда
		ЗаданноеЗначение = Параметр.Значение;
	Иначе
		// Установка значения, когда пользователь не использовал отбор
		ЗаданноеЗначение = ЗначениеКогдаНеИспользуется;
	КонецЕсли;
	
	Если ТипЗнч(ЗаданноеЗначение) = Тип("СписокЗначений") Тогда
		// Создание нового списка для расширения состава типов значения
		НовыйСписок = Новый СписокЗначений;
		НовыйСписок.ЗагрузитьЗначения(ЗаданноеЗначение.ВыгрузитьЗначения());
		ЗаданноеЗначение = НовыйСписок;
		// Установка значения, когда пользователь задал Неопределено
		Элемент = ЗаданноеЗначение.НайтиПоЗначению(Неопределено);
		Если Элемент <> Неопределено Тогда
			Элемент.Значение = ЗначениеПриНеопределено;
		КонецЕсли;
		//
	ИначеЕсли ЗаданноеЗначение = Неопределено Тогда
		// Установка значения, когда пользователь задал Неопределено
		ЗаданноеЗначение = ЗначениеПриНеопределено;
	КонецЕсли;
	
	ПараметрыДанных.Текущие.УстановитьЗначениеПараметра(ИмяОбязательногоПараметра, ЗаданноеЗначение);
	
КонецПроцедуры


#КонецЕсли