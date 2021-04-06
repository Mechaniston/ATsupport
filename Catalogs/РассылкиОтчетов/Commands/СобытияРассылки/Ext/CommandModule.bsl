﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

&НаКлиенте
Процедура ОбработкаКоманды(Рассылка, Параметры)
	// Получение даты последнего запуска
	ПоследнийЗапуск = Неопределено;
	Если Параметры.Источник.ИмяФормы = "Справочник.РассылкиОтчетов.Форма.ФормаСписка" Тогда
		ДанныеСписка = Параметры.Источник.Элементы.Список.ТекущиеДанные;
		Если ДанныеСписка <> Неопределено Тогда
			ПоследнийЗапуск = ДанныеСписка.ПоследнийЗапуск;
		КонецЕсли;
	КонецЕсли;
	Если ПоследнийЗапуск = Неопределено Тогда
		ПоследнийЗапуск = ПоследнийЗапускРассылки(Рассылка);
	КонецЕсли;
	
	// Параметры формы
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Данные", Рассылка);
	Если ПоследнийЗапуск <> Неопределено Тогда
		ПараметрыФормы.Вставить("ДатаНачала", ПоследнийЗапуск);
	КонецЕсли;
	
	ОткрытьФорму("Обработка.ЖурналРегистрации.Форма", ПараметрыФормы, Параметры.Источник, Параметры.Уникальность, Параметры.Окно);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Функция ПоследнийЗапускРассылки(Рассылка)
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Состояния.ПоследнийЗапуск
	|ИЗ
	|	РегистрСведений.СостоянияРассылокОтчетов КАК Состояния
	|ГДЕ
	|	Состояния.Рассылка = &Рассылка";
	Запрос.УстановитьПараметр("Рассылка", Рассылка);
	
	УстановитьПривилегированныйРежим(Истина);
	Выборка = Запрос.Выполнить().Выбрать();
	УстановитьПривилегированныйРежим(Истина);
	Результат = ?(Выборка.Следующий(), Выборка.ПоследнийЗапуск, Неопределено);
	Возврат Результат;
КонецФункции

