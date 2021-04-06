﻿
#Область ПрограммныйИнтерфейс

//!! Устаревшие функции - новые в ВнутреннегоИспользования_ВызовСервера {

// Возвращает список пользователей имеющих переданную роль
//
// Параметры:
//	ИмяРоли - Строка - Имя роли.
//
// Возвращаемое значение:
//	СписокЗначений
//
Функция   ПолучитьСписокПользователей(ИмяРоли) Экспорт //сервер
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Пользователи.Ссылка
		|ИЗ
		|	Справочник.Пользователи КАК Пользователи
		|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ РАЗЛИЧНЫЕ
		|			ГруппыПользователейСостав.Пользователь КАК Пользователь
		|		ИЗ
		|			Справочник.ГруппыПользователей.Состав КАК ГруппыПользователейСостав
		|		ГДЕ
		|			ГруппыПользователейСостав.Ссылка В ИЕРАРХИИ
		|					(ВЫБРАТЬ
		|						ГруппыДоступаПользователи.Пользователь КАК Пользователь
		|					ИЗ
		|						Справочник.ИдентификаторыОбъектовМетаданных КАК ИдентификаторыОбъектовМетаданных
		|							ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПрофилиГруппДоступа.Роли КАК ПрофилиГруппДоступаРоли
		|								ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ГруппыДоступа.Пользователи КАК ГруппыДоступаПользователи
		|								ПО
		|									ПрофилиГруппДоступаРоли.Ссылка = ГруппыДоступаПользователи.Ссылка.Профиль
		|										И ГруппыДоступаПользователи.Пользователь ССЫЛКА Справочник.ГруппыПользователей
		|							ПО
		|								ИдентификаторыОбъектовМетаданных.Ссылка = ПрофилиГруппДоступаРоли.Роль
		|					ГДЕ
		|						ИдентификаторыОбъектовМетаданных.Родитель = ЗНАЧЕНИЕ(Справочник.ИдентификаторыОбъектовМетаданных.Роли)
		|						И ИдентификаторыОбъектовМетаданных.Имя = &ИмяРоли)
		|			И НЕ ГруппыПользователейСостав.Ссылка.ПометкаУдаления
		|		
		|		ОБЪЕДИНИТЬ ВСЕ
		|		
		|		ВЫБРАТЬ РАЗЛИЧНЫЕ
		|			ВЫБОР
		|				КОГДА НЕ ВЫРАЗИТЬ(ГруппыДоступаПользователи.Пользователь КАК Справочник.Пользователи) ЕСТЬ NULL 
		|					ТОГДА ГруппыДоступаПользователи.Пользователь
		|				КОГДА НЕ ГруппыДоступаПользователи.Ссылка.Пользователь ЕСТЬ NULL 
		|					ТОГДА ГруппыДоступаПользователи.Ссылка.Пользователь
		|			КОНЕЦ
		|		ИЗ
		|			Справочник.ИдентификаторыОбъектовМетаданных КАК ИдентификаторыОбъектовМетаданных
		|				ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПрофилиГруппДоступа.Роли КАК ПрофилиГруппДоступаРоли
		|					ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ГруппыДоступа.Пользователи КАК ГруппыДоступаПользователи
		|					ПО ПрофилиГруппДоступаРоли.Ссылка = ГруппыДоступаПользователи.Ссылка.Профиль
		|				ПО ИдентификаторыОбъектовМетаданных.Ссылка = ПрофилиГруппДоступаРоли.Роль
		|		ГДЕ
		|			ИдентификаторыОбъектовМетаданных.Родитель = ЗНАЧЕНИЕ(Справочник.ИдентификаторыОбъектовМетаданных.Роли)
		|			И ИдентификаторыОбъектовМетаданных.Имя = &ИмяРоли
		|			И НЕ ГруппыДоступаПользователи.Ссылка.ПометкаУдаления
		|			И НЕ ПрофилиГруппДоступаРоли.Ссылка.ПометкаУдаления) КАК ВложенныйЗапрос
		|		ПО Пользователи.Ссылка = ВложенныйЗапрос.Пользователь
		|ГДЕ
		|	НЕ ВложенныйЗапрос.Пользователь ЕСТЬ NULL
		|	И НЕ Пользователи.ПометкаУдаления
		|";
	
	Запрос.УстановитьПараметр("ИмяРоли", ИмяРоли);
	
	УстановитьПривилегированныйРежим(Истина);
	
	СписокПользователей = Новый СписокЗначений;
	СписокПользователей.ЗагрузитьЗначения(Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"));
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат СписокПользователей;
	
КонецФункции

Функция   ПолучитьСписокПильзователейПоНесколькимРолям(Роли) Экспорт
	
	СписокПользователей = Новый СписокЗначений;
	
	Для Каждого ИмяРоли Из Роли Цикл
		
		СписокПользователейРоли = ПолучитьСписокПользователей(ИмяРоли);
		
		Для Каждого ЭлементСпискаПользователейРоли Из СписокПользователейРоли Цикл
			
			СписокПользователей.Добавить(ЭлементСпискаПользователейРоли.Значение);
			
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат СписокПользователей;
	
КонецФункции

//!! Устаревшие функции }

Функция   ПолучитьКонтрагентаДляОрганизации(Организация) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ДополнительныеРеквизитыОрганизаций_ат.Контрагент
		|ИЗ
		|	РегистрСведений.ДополнительныеРеквизитыОрганизаций_ат КАК ДополнительныеРеквизитыОрганизаций_ат
		|ГДЕ
		|	ДополнительныеРеквизитыОрганизаций_ат.Организация = &Организация
		|	И НЕ ДополнительныеРеквизитыОрганизаций_ат.Контрагент.ПометкаУдаления
		|";
	
	Запрос.УстановитьПараметр("Организация", Организация);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Контрагент;
	Иначе
		Возврат Справочники.Контрагенты_ат.ПустаяСсылка();
	КонецЕсли;
	
КонецФункции

// Возвращает ссылку на спр.Контрагенты, которая указывает на основного для Пользователя, согласно РС.СпецификацияПользователей
//
// Параметры:
//  Пользователь  - СправочникСсылка.Пользователи - Пользователь для которого ищем организации
//
// Возвращаемое значение:
//   ТаблицаЗначений   - Возвращает колонки: контрагенты(ссылка) и маркер "основной" (булево)
//
&НаСервере
Функция   ПолучитьОсновногоКонтрагентаПользователя(Пользователь) Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ РАЗРЕШЕННЫЕ
		|	СпецификацияПользователей.Контрагент,
		|	СпецификацияПользователей.Основной
		|ИЗ
		|	РегистрСведений.СпецификацияПользователей_ат КАК СпецификацияПользователей
		|ГДЕ
		|	СпецификацияПользователей.Пользователь = &Пользователь
		|	И НЕ СпецификацияПользователей.Контрагент.ПометкаУдаления
		|";
	
	Запрос.УстановитьПараметр("Пользователь", Пользователь);
	ВРЗ = Запрос.Выполнить().Выбрать();
	
	Если ВРЗ.Количество() > 1 Тогда
		
		Пока ВРЗ.Следующий() Цикл
			
			Если ВРЗ.Основной Тогда
				Возврат ВРЗ.Контрагент;
			КонецЕсли;
			
		КонецЦикла;
		
		//ВРЗ.Сбросить();
		//ВРЗ.Следующий();
		
		Возврат Неопределено; //ВРЗ.Контрагент;
		
	Иначе
		
		Если ВРЗ.Количество() = 1 Тогда
			ВРЗ.Следующий();
			Возврат ВРЗ.Контрагент;
		КонецЕсли;
		
	КонецЕсли
	
КонецФункции

Функция   КонтрагентЯвляетсяВнутренним(Контрагент) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	1 КАК Индикатор
		|ИЗ
		|	РегистрСведений.ДополнительныеРеквизитыОрганизаций_ат КАК ДополнительныеРеквизитыОрганизаций_ат
		|ГДЕ
		|	ДополнительныеРеквизитыОрганизаций_ат.Контрагент = &Контрагент";
	
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат НЕ РезультатЗапроса.Пустой();
	
КонецФункции

#КонецОбласти
