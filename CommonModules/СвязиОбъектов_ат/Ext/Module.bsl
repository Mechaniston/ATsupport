﻿
// Связи Объектов (с) Вячеслав 'Mechanist' А. Павлов, 2012

// Реализует управление связями и получение данных о них для различных объектов (определяются типом значения измерений Объект и Предок
// в РегистреСведений.СвязиОбъектов_ат).
//
// Связи представляют собой ориентированный направленный полный слабо связный простой ациклический граф
// (или же слабый ациклический турнир или же направленный полный слабый гамак ;) - за подробностями велкам в теорию графов).
//
// Если просто, то - связи между объектами направленные (т.е. от предка к объекту), без петель (нельзя объект связать сам с собой),
// без контуров (циклов) (нельзя создать связь для объекта с любым другим объектом уже с ним состоящим в связи, через любое кол-во узлов).
// Количество связей объектов - не ограничено.
//
// Выбранный вариант хранения данных о связях направлен на оптимальное быстродействие для нахождения предков и потомков конкретного объекта.
// Наиболее затратна операция изменения связей в "корневых" элементах графа (имеющих максимальное количество потомков).
// Количество хранимых данных так же неоптимально с точки зрения объема, но это обусловлено целью указанной выше.
//
// Учитывайте, что операции изменения связей с потомками работают через процедуры работы с предками.


// *** Получение информации о предках

// Возвращает массив предков объекта.
Функция   ПолучитьПредковОбъекта(Объект, ТолькоНепосредственных = Ложь, ИмяРегистра = "СвязиОбъектов_ат", ДопУсловие = "") Экспорт
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	СвязиОбъектов.Предок КАК Объект
		|ИЗ
		|	РегистрСведений." + ИмяРегистра + " КАК СвязиОбъектов
		|ГДЕ
		|	СвязиОбъектов.Объект = &Объект"
		+ ?(ПустаяСтрока(ДопУсловие), "", " И " + ДопУсловие));
	
	Если ТолькоНепосредственных Тогда
		Запрос.Текст = Запрос.Текст + "
			|И СвязиОбъектов.СсылкаНаКод = 0";
	КонецЕсли;
	
	Запрос.УстановитьПараметр("Объект", Объект);
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Объект");
	
КонецФункции

// Заполняет дерево предками объекта. Непосредственные предки составляют корневые элементы дерева. Т.к. граф отображается на дерево,
// то возможны повторы одних и тех же объектов в различных ветках дерева.
Процедура ЗаполнитьДеревоПредков(Объект, Дерево, ИмяРегистра = "СвязиОбъектов_ат") Экспорт
	
	Дерево.Строки.Очистить();
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	СвязиОбъектов.Код КАК Код,
		|	СвязиОбъектов.Предок КАК Предок,
		|	СвязиОбъектов.Объект КАК Объект,
		|	СвязиОбъектов.ТипСвязи КАК ТипСвязи,
		|	СвязиОбъектов.СсылкаНаКод КАК СсылкаНаКод
		|ИЗ
		|	РегистрСведений." + ИмяРегистра + " КАК СвязиОбъектов
		|ГДЕ
		|	СвязиОбъектов.Объект = &Объект
		|УПОРЯДОЧИТЬ ПО
		|	СвязиОбъектов.СсылкаНаКод, СвязиОбъектов.Код");
	
	Запрос.УстановитьПараметр("Объект", Объект);
	ТаблицаПредков = Запрос.Выполнить().Выгрузить();
	
	Если ТаблицаПредков.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ТаблицаПредков.Индексы.Добавить("Код");
	
	Для Каждого СтрокаТаблицыПредков Из ТаблицаПредков Цикл
		ТекущаяСтрокаДерева = Дерево.Строки;
		Пока СтрокаТаблицыПредков.СсылкаНаКод > 0 Цикл
			Запрос = Новый Запрос(
				"ВЫБРАТЬ ПЕРВЫЕ 1
				|	СвязиОбъектов.Код КАК Код,
				|	СвязиОбъектов.Предок КАК Предок,
				|	СвязиОбъектов.Объект КАК Объект,
				|	СвязиОбъектов.ТипСвязи КАК ТипСвязи,
				|	СвязиОбъектов.СсылкаНаКод КАК СсылкаНаКод
				|ИЗ
				|	РегистрСведений." + ИмяРегистра + " КАК СвязиОбъектов
				|ГДЕ
				|	СвязиОбъектов.Код = &Код");
			Запрос.УстановитьПараметр("Код", СтрокаТаблицыПредков.СсылкаНаКод);
			ДальнийПредок = Запрос.Выполнить().Выбрать();
			
			Если ДальнийПредок.Количество() > 0 Тогда
				ДальнийПредок.Следующий();
			Иначе
				Прервать;
			КонецЕсли;
			
			СуществующийПредок = ТекущаяСтрокаДерева.Найти(ДальнийПредок.Объект, "Объект");
			Если СуществующийПредок = Неопределено Тогда
				Предок = ТекущаяСтрокаДерева.Добавить();
				Предок.Объект = ДальнийПредок.Предок;
				СвязиОбъектов_Переопределяемый_ат.ЗаполнениеСтрокиДерева(Предок, ДальнийПредок);
				ТекущаяСтрокаДерева = Предок.Строки;
			Иначе
				ТекущаяСтрокаДерева = СуществующийПредок.Строки;
			КонецЕсли;
			
			ЗаполнитьЗначенияСвойств(СтрокаТаблицыПредков, ДальнийПредок);
		КонецЦикла;
		Предок = ТекущаяСтрокаДерева.Добавить();
		Предок.Объект = СтрокаТаблицыПредков.Предок;
		СвязиОбъектов_Переопределяемый_ат.ЗаполнениеСтрокиДерева(Предок, СтрокаТаблицыПредков);
	КонецЦикла;
	
КонецПроцедуры

// АФ - агрегатная(ые) функция(ии). Может быть либо строкой, либо массивом строк. ПараметрыАФ должны быть соответствующего типа (и,
// соответственно, во втором случае массив параметров должен иметь такое же кол-во элементов как и массив АФ)
Функция   ВычислитьЗначениеАФДляПредков(Объект, АФ, ПараметрыАФ, ТолькоДляНепосредственных = Ложь, ДопУсловия = "", ИмяРегистра = "СвязиОбъектов_ат") Экспорт
	
	Возврат ВычислитьЗначениеАФДля("Объект", Объект, АФ, ПараметрыАФ, ТолькоДляНепосредственных, ДопУсловия, ИмяРегистра);
	
КонецФункции

// *** Получение информации о потомках

// Возвращает массив потомков объекта
Функция   ПолучитьПотомковОбъекта(Объект, ТолькоНепосредственных = Ложь, ИмяРегистра = "СвязиОбъектов_ат", ДопУсловие = "") Экспорт
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	СвязиОбъектов.Объект КАК Объект
		|ИЗ
		|	РегистрСведений." + ИмяРегистра + " КАК СвязиОбъектов
		|ГДЕ
		|	СвязиОбъектов.Предок = &Объект"
		+ ?(ПустаяСтрока(ДопУсловие), "", " И " + ДопУсловие));
	
	Если ТолькоНепосредственных Тогда
		Запрос.Текст = Запрос.Текст + "
			|И СвязиОбъектов.СсылкаНаКод = 0";
	КонецЕсли;
	
	Запрос.УстановитьПараметр("Объект", Объект);
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Объект");
	
КонецФункции

// Заполняет дерево потомками объекта. Непосредственные потомки составляют корневые элементы дерева. Т.к. граф отображается на дерево,
// то возможны повторы одних и тех же объектов в различных ветках дерева.
Процедура ЗаполнитьДеревоПотомков(Объект, Дерево, ИмяРегистра = "СвязиОбъектов_ат") Экспорт
	
	Дерево.Строки.Очистить();
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	СвязиОбъектов.Код КАК Код,
		|	СвязиОбъектов.Предок КАК Предок,
		|	СвязиОбъектов.Объект КАК Объект,
		|	СвязиОбъектов.ТипСвязи КАК ТипСвязи,
		|	СвязиОбъектов.СсылкаНаКод КАК СсылкаНаКод
		|ИЗ
		|	РегистрСведений." + ИмяРегистра + " КАК СвязиОбъектов
		|ГДЕ
		|	СвязиОбъектов.Предок = &Объект
		|УПОРЯДОЧИТЬ ПО
		|	СвязиОбъектов.СсылкаНаКод, СвязиОбъектов.Код");
	
	Запрос.УстановитьПараметр("Объект", Объект);
	ТаблицаПотомков = Запрос.Выполнить().Выгрузить();
	
	Если ТаблицаПотомков.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ТаблицаПотомков.Индексы.Добавить("Код");
	ТаблицаПотомков.Колонки.Добавить("СсылкаНаСтроку");
	
	Для Каждого СтрокаТаблицыПотомков Из ТаблицаПотомков Цикл
		СтрокаРодителя = Неопределено;
		Если СтрокаТаблицыПотомков.СсылкаНаКод > 0 Тогда
			ПоискРодителя = ТаблицаПотомков.Найти(СтрокаТаблицыПотомков.СсылкаНаКод, "Код");
			Если ПоискРодителя <> Неопределено Тогда
				СтрокаРодителя = ПоискРодителя.СсылкаНаСтроку;
			КонецЕсли;
		КонецЕсли;
		Если СтрокаРодителя = Неопределено Тогда
			СтрокаРодителя = Дерево.Строки;
		КонецЕсли;
		Потомок = СтрокаРодителя.Добавить();
		Потомок.Объект = СтрокаТаблицыПотомков.Объект;
		СвязиОбъектов_Переопределяемый_ат.ЗаполнениеСтрокиДерева(Потомок, СтрокаТаблицыПотомков);
		СтрокаТаблицыПотомков.СсылкаНаСтроку = Потомок.Строки;
	КонецЦикла;
		
КонецПроцедуры

// АФ - агрегатная(ые) функция(ии). Может быть либо строкой, либо массивом строк. ПараметрыАФ должны быть соответствующего типа (и,
// соответственно, во втором случае массив параметров должен иметь такое же кол-во элементов как и массив АФ).
Функция   ВычислитьЗначениеАФДляПотомков(Объект, АФ, ПараметрыАФ, ТолькоДляНепосредственных = Ложь, ИмяРегистра = "СвязиОбъектов_ат") Экспорт
	
	Возврат ВычислитьЗначениеАФДля("Предок", Объект, АФ, ПараметрыАФ, ТолькоДляНепосредственных, , ИмяРегистра);
	
КонецФункции

// *** Основные процедуры для изменения (установки и удаления) связей

Процедура УстановитьПредковОбъекта(Объект, МассивПредков, БезТранзакции = Ложь, ТипСвязи = Неопределено, ИмяРегистра = "СвязиОбъектов_ат") Экспорт
	
	// сначала определим, что не надо трогать - т.е. какие связи с предками остаются + контрольки
	
	ПотомкиОбъекта = ПолучитьПотомковОбъекта(Объект, , ИмяРегистра);
	
	УдаляемыеПредки = ПолучитьПредковОбъекта(Объект, Истина, ИмяРегистра);
	НовыеПредки = Новый Массив;
	Для Каждого Предок Из МассивПредков Цикл
		ИндексПредка = УдаляемыеПредки.Найти(Предок);
		Если ИндексПредка <> Неопределено Тогда
			УдаляемыеПредки.Удалить(ИндексПредка);
		ИначеЕсли Предок <> Объект И ПотомкиОбъекта.Найти(Предок) = Неопределено Тогда // исключаем связь объекта с самим собой и потомками
			НовыеПредки.Добавить(Предок);
		КонецЕсли;
	КонецЦикла;
	
	Попытка
		Если Не БезТранзакции Тогда
			НачатьТранзакцию();
		КонецЕсли;
		
		Если УдаляемыеПредки.Количество() > 0 Тогда
			УдалитьСвязиСПредкамиОбъекта(Объект, УдаляемыеПредки, ПотомкиОбъекта, ИмяРегистра);
		КонецЕсли;
	
		Если НовыеПредки.Количество() > 0 Тогда
			ДобавитьСвязиСПредкамиОбъекта(Объект, НовыеПредки, ПотомкиОбъекта, ТипСвязи, ИмяРегистра);
		КонецЕсли;
			
		Если Не БезТранзакции Тогда
			ЗафиксироватьТранзакцию();
		КонецЕсли;
	Исключение
		Сообщить("СвязиОбъектов: " + ОписаниеОшибки(), СтатусСообщения.Важное);
		Если Не БезТранзакции Тогда
			ОтменитьТранзакцию();
		Иначе
			ВызватьИсключение;
		КонецЕсли;
	КонецПопытки;
	
КонецПроцедуры

Процедура УстановитьПотомковОбъекта(Объект, МассивПотомков, БезТранзакции = Ложь, ТипСвязи = Неопределено, ИмяРегистра = "СвязиОбъектов_ат") Экспорт
	
	ПредкиОбъекта = ПолучитьПредковОбъекта(Объект, , ИмяРегистра);
	
	УдаляемыеПотомки = ПолучитьПотомковОбъекта(Объект, Истина, ИмяРегистра);
	НовыеПотомки = Новый Массив;
	
	Для Каждого Потомок Из МассивПотомков Цикл
		ИндексПотомка = УдаляемыеПотомки.Найти(Потомок);
		Если ИндексПотомка <> Неопределено Тогда
			УдаляемыеПотомки.Удалить(ИндексПотомка);
		ИначеЕсли Потомок <> Объект И ПредкиОбъекта.Найти(Потомок) = Неопределено Тогда // исключаем связь объекта с самим собой и потомками
			НовыеПотомки.Добавить(Потомок);
		КонецЕсли;
	КонецЦикла;
	
	Попытка
		Если Не БезТранзакции Тогда
			НачатьТранзакцию();
		КонецЕсли;
		
		МассивИзОбъекта = Новый Массив;
		МассивИзОбъекта.Добавить(Объект);

		Для Каждого УдаляемыйПотомок Из УдаляемыеПотомки Цикл
			УдалитьСвязиСПредкамиОбъекта(УдаляемыйПотомок, МассивИзОбъекта, , ИмяРегистра);
		КонецЦикла;
		Для Каждого НовыйПотомок Из НовыеПотомки Цикл
			ДобавитьСвязиСПредкамиОбъекта(НовыйПотомок, МассивИзОбъекта, , ТипСвязи, ИмяРегистра);
		КонецЦикла;
		
		Если Не БезТранзакции Тогда
			ЗафиксироватьТранзакцию();
		КонецЕсли;
	Исключение
		Сообщить("СвязиОбъектов: " + ОписаниеОшибки(), СтатусСообщения.Важное);
		Если Не БезТранзакции Тогда
			ОтменитьТранзакцию();
		Иначе
			ВызватьИсключение;
		КонецЕсли;
	КонецПопытки;
	
КонецПроцедуры

Процедура УстановитьПредковИПотомковОбъекта(Объект, МассивПредков, МассивПотомков, ТипСвязи = Неопределено, ИмяРегистра = "СвязиОбъектов_ат") Экспорт
	
	Попытка
		НачатьТранзакцию();
		
		СвязиОбъектов_ат.УстановитьПредковОбъекта(Объект, МассивПредков, Истина, ТипСвязи, ИмяРегистра);
		
		СвязиОбъектов_ат.УстановитьПотомковОбъекта(Объект, МассивПотомков, Истина, ТипСвязи, ИмяРегистра); 
		
		ЗафиксироватьТранзакцию();
	Исключение
		Сообщить("СвязиОбъектов: " + ОписаниеОшибки(), СтатусСообщения.Важное);
		ОтменитьТранзакцию();
	КонецПопытки;
	
КонецПроцедуры

// ** Низкоуровневые процедуры установки связей (без проверок, анализа и транзакций)

Процедура УдалитьСвязиСПредкамиОбъекта(Объект, МассивУдаляемыхПредков, ПотомкиОбъекта = Неопределено, ИмяРегистра = "СвязиОбъектов_ат") Экспорт
	
	Если ПотомкиОбъекта = Неопределено Тогда
		ПотомкиОбъекта = ПолучитьПотомковОбъекта(Объект, , ИмяРегистра);
	КонецЕсли;
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	СвязиОбъектов.Код КАК Код,
		|	СвязиОбъектов.Предок КАК Предок
		|ИЗ
		|	РегистрСведений." + ИмяРегистра + " КАК СвязиОбъектов
		|ГДЕ
		|	(СвязиОбъектов.Объект = &Объект
		|		И СвязиОбъектов.Предок В (&Предки)
		|		И СвязиОбъектов.СсылкаНаКод = 0)
		|	ИЛИ
		|		СвязиОбъектов.Объект В (&Предки)"); 
	Запрос.УстановитьПараметр("Объект", Объект);
	Запрос.УстановитьПараметр("Предки", МассивУдаляемыхПредков);
	ТЗУдаляемыхПредков = Запрос.Выполнить().Выгрузить();
	МассивУдаляемыхКодов = ТЗУдаляемыхПредков.ВыгрузитьКолонку("Код");
	МассивПредков = ТЗУдаляемыхПредков.ВыгрузитьКолонку("Предок");
	
	Если МассивУдаляемыхКодов.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	МассивОбъектов = Новый Массив;
	
	ТекущийИндекс = 0;
	Пока ТекущийИндекс < МассивУдаляемыхКодов.Количество() Цикл
		Запрос = Новый Запрос(
			"ВЫБРАТЬ
			|	СвязиОбъектов.Код КАК Код,
			|	СвязиОбъектов.Объект КАК Объект
			|ИЗ
			|	РегистрСведений." + ИмяРегистра + " КАК СвязиОбъектов
			|ГДЕ
			|	СвязиОбъектов.СсылкаНаКод = &СсылкаНаКод");
		Запрос.УстановитьПараметр("СсылкаНаКод", МассивУдаляемыхКодов[ТекущийИндекс]);
		ВРЗ = Запрос.Выполнить().Выбрать();
		Пока ВРЗ.Следующий() Цикл
			Если МассивУдаляемыхКодов.Найти(ВРЗ.Код) = Неопределено Тогда
				МассивУдаляемыхКодов.Добавить(ВРЗ.Код);
			КонецЕсли;
			//Если МассивОбъектов.Найти(ВРЗ.Объект) = Неопределено И ПотомкиОбъекта.Найти(ВРЗ.Объект) <> Неопределено Тогда
			//	МассивОбъектов.Добавить(ВРЗ.Объект);
			//КонецЕсли;
		КонецЦикла;
		ТекущийИндекс = ТекущийИндекс + 1;
	КонецЦикла;
	
	МассивОбъектов.Добавить(Объект);
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	СвязиОбъектов.Код КАК Код,
		|	СвязиОбъектов.Объект КАК Объект,
		|	СвязиОбъектов.Предок КАК Предок
		|ИЗ
		|	РегистрСведений." + ИмяРегистра + " КАК СвязиОбъектов
		|ГДЕ
		|//	СвязиОбъектов.Объект В (&Объекты)
		|	СвязиОбъектов.Предок В (&Предки)
		|	И СвязиОбъектов.СсылкаНаКод В (&СсылкиНаКоды)");
	//Запрос.УстановитьПараметр("Объекты", МассивОбъектов);
	Запрос.УстановитьПараметр("Предки", МассивПредков);
	Запрос.УстановитьПараметр("СсылкиНаКоды", МассивУдаляемыхКодов);
	ВРЗ = Запрос.Выполнить().Выбрать();
	
	СвязьОбъекта = РегистрыСведений.СвязиОбъектов_ат.СоздатьМенеджерЗаписи();
	Пока ВРЗ.Следующий() Цикл
		СвязьОбъекта.Код = ВРЗ.Код;
		СвязьОбъекта.Объект = ВРЗ.Объект;
		СвязьОбъекта.Предок = ВРЗ.Предок;
		СвязьОбъекта.Прочитать();
		Если СвязьОбъекта.Выбран() Тогда
			СвязьОбъекта.Удалить();
			//Сообщить("Связи объектов: удалена косвенная связь #" + ВРЗ.Код + " объекта <" + ВРЗ.Объект
			//	+ "> с объектом-предком <" + ВРЗ.Предок + ">", СтатусСообщения.Информация);
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого УдаляемыйПредок Из МассивУдаляемыхПредков Цикл
		СтрокаУдаляемогоПредка = ТЗУдаляемыхПредков.Найти(УдаляемыйПредок, "Предок"); // для поиска Кода
		Если СтрокаУдаляемогоПредка <> Неопределено Тогда
			СвязьОбъекта.Код = СтрокаУдаляемогоПредка.Код;
			СвязьОбъекта.Объект = Объект;
			СвязьОбъекта.Предок = УдаляемыйПредок;
			СвязьОбъекта.Прочитать();
			Если СвязьОбъекта.Выбран() Тогда
				СвязьОбъекта.Удалить();
				//Сообщить("Связи объектов: удалена связь #" + СтрокаУдаляемогоПредка.Код + " объекта <" + Объект
				//	+ "> с объектом-предком <" + УдаляемыйПредок + ">", СтатусСообщения.Информация);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура ДобавитьСвязиСПредкамиОбъекта(Объект, МассивНовыхПредков, ПотомкиОбъекта = Неопределено, ТипСвязи = Неопределено, ИмяРегистра = "СвязиОбъектов_ат") Экспорт
	
	Если ПотомкиОбъекта = Неопределено Тогда
		ПотомкиОбъекта = ПолучитьПотомковОбъекта(Объект, , ИмяРегистра);
	КонецЕсли;
	
	// получаем прямые связи потомков друг с другом
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	СвязиОбъектов.Код КАК Код,
		|	СвязиОбъектов.Объект КАК Объект,
		|	СвязиОбъектов.Предок КАК Предок
		|ИЗ
		|	РегистрСведений." + ИмяРегистра + " КАК СвязиОбъектов
		|ГДЕ
		|	СвязиОбъектов.СсылкаНаКод = 0
		|	И СвязиОбъектов.Объект В (&Объекты)
		|
		|УПОРЯДОЧИТЬ ПО
		|	СвязиОбъектов.Код");
	Запрос.УстановитьПараметр("Объекты", ПотомкиОбъекта);
	ТЗПрямыхСвязейПотомков = Запрос.Выполнить().Выгрузить();
	
	Код = ПолучитьНовыйКод(ИмяРегистра);
	
	НаборСвязейОбъекта = РегистрыСведений.СвязиОбъектов_ат.СоздатьНаборЗаписей();
	ТЗСвязейОбъекта = НаборСвязейОбъекта.Выгрузить();
	
	Для Каждого Предок Из МассивНовыхПредков Цикл
		ТЗСвязейОбъекта.Очистить();
		СоздатьЗаписиСвязейОбъектаСПредком(Объект, Предок, ТЗСвязейОбъекта, Код, ТипСвязи, ИмяРегистра);
		
		КоличествоСвязей = ТЗСвязейОбъекта.Количество();
		ИндексСвязи = 0;
		
		Пока ИндексСвязи < КоличествоСвязей Цикл
			НовыйПредок = ТЗСвязейОбъекта[ИндексСвязи].Предок;
			ТипСвязиСНовымПредком = ТЗСвязейОбъекта[ИндексСвязи].ТипСвязи;
			
			Для Каждого Потомок Из ПотомкиОбъекта Цикл
				ОтборСвязейПотомка = Новый Структура;
				ОтборСвязейПотомка.Вставить("Объект", Потомок);
				
				МассивСвязейПотомка = ТЗПрямыхСвязейПотомков.НайтиСтроки(ОтборСвязейПотомка);
				Для Каждого СтрокаСвязиПотомка Из МассивСвязейПотомка Цикл
					ПрямойПредокПотомка = СтрокаСвязиПотомка.Предок;
					
					ОтборИзНовыхСвязей = Новый Структура;
					ОтборИзНовыхСвязей.Вставить("Объект", ПрямойПредокПотомка);
					ОтборИзНовыхСвязей.Вставить("Предок", НовыйПредок);
					
					МассивИзНовыхСвязей = ТЗСвязейОбъекта.НайтиСтроки(ОтборИзНовыхСвязей);
					СсылочныеКоды = Новый Массив; // надо заренее извлечь нужные коды, т.к. при ТЗСвязейОбъекта.Добавить(), может произойти их пересортица,
					Для Каждого СтрокаИхНовыхСвязей Из МассивИзНовыхСвязей Цикл		// потому что НайтиСтроки возвращает ссылки на строки, а не их копию
						СсылочныеКоды.Добавить(СтрокаИхНовыхСвязей.Код);
					КонецЦикла;
					
					Для Каждого СсылочныйКод Из СсылочныеКоды Цикл
						Связь = ТЗСвязейОбъекта.Добавить();
						
						Связь.Код = Код;
						Связь.Предок = НовыйПредок;
						Связь.Объект = Потомок;
						Связь.СсылкаНаКод = СсылочныйКод;
						Связь.ТипСвязи = ТипСвязиСНовымПредком;
						
						//Сообщить("Связи объектов: добавлена косвенная связь #" + Код + " объекта-потомка <" + Потомок
						//	+ "> с объектом-предком <" + НовыйПредок + ">", СтатусСообщения.Информация);
						
						Код = Код + 1;
					КонецЦикла;
				КонецЦикла;
			КонецЦикла;
			ИндексСвязи = ИндексСвязи + 1;
		КонецЦикла;
	
		Если ТЗСвязейОбъекта.Количество() = 0 Тогда
			Продолжить;;
		КонецЕсли;
		
		НаборСвязейОбъекта.Очистить();
		Предок = ТЗСвязейОбъекта[0].Предок;
		НаборСвязейОбъекта.Отбор.Предок.Установить(Предок);
		
		Для Каждого СтрокаСвязиОбъекта Из ТЗСвязейОбъекта Цикл
			Если Предок <> СтрокаСвязиОбъекта.Предок Тогда
				НаборСвязейОбъекта.Записать(Ложь);
				НаборСвязейОбъекта.Очистить();
				Предок = СтрокаСвязиОбъекта.Предок;
				НаборСвязейОбъекта.Отбор.Предок.Установить(Предок);
			КонецЕсли;
			СтрокаНабораСвязейОбъекта = НаборСвязейОбъекта.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаНабораСвязейОбъекта, СтрокаСвязиОбъекта);
		КонецЦикла;
		
		НаборСвязейОбъекта.Записать(Ложь);
	КонецЦикла;
	
КонецПроцедуры

// * Технические процедуры

Функция   ПолучитьНовыйКод(ИмяРегистра = "СвязиОбъектов_ат")
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	МАКСИМУМ(СвязиОбъектов.Код) КАК Код
		|ИЗ
		|	РегистрСведений." + ИмяРегистра + " КАК СвязиОбъектов
		|
		|ДЛЯ ИЗМЕНЕНИЯ");
	ВРЗ = Запрос.Выполнить().Выбрать();
 	ВРЗ.Следующий();
	
	Если ВРЗ.Код = Null Тогда
		Возврат 1;
	Иначе
		Возврат ВРЗ.Код + 1;
	КонецЕсли;
	
КонецФункции

Процедура СоздатьЗаписиСвязейОбъектаСПредком(Объект, Предок, СвязиОбъекта, Код, ТипСвязи = Неопределено, ИмяРегистра = "СвязиОбъектов_ат")
	
	// - создаем прямую связь
	
	Связь = СвязиОбъекта.Добавить();
	Связь.Предок = Предок;
	Связь.Объект = Объект;
	Связь.Код = Код;
	Связь.ТипСвязи = ТипСвязи;
	
	//Сообщить("Связи объектов: добавлена связь #" + Код + " объекта <" + Объект
	//	+ "> с объектом-предком <" + Предок + ">", СтатусСообщения.Информация);
	
	Код = Код + 1;
	
	// - создаем связь с предками предков
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	СвязиОбъектов.Код КАК Код,
		|	СвязиОбъектов.Предок КАК Предок,
		|	СвязиОбъектов.ТипСвязи КАК ТипСвязи
		|ИЗ
		|	РегистрСведений." + ИмяРегистра + " КАК СвязиОбъектов
		|ГДЕ
		|	СвязиОбъектов.Объект = &Объект
		|
		|УПОРЯДОЧИТЬ ПО
		|	СвязиОбъектов.Код");
	Запрос.УстановитьПараметр("Объект", Предок);
	ВРЗ = Запрос.Выполнить().Выбрать();
	
	Пока ВРЗ.Следующий() Цикл
		Связь = СвязиОбъекта.Добавить();
		Связь.Предок = ВРЗ.Предок;
		Связь.Объект = Объект;
		Связь.Код = Код;
		Связь.СсылкаНаКод = ВРЗ.Код;
		Связь.ТипСвязи = ВРЗ.ТипСвязи;
		
		//Сообщить("Связи объектов: добавлена косвенная связь #" + Код + " объекта <" + Объект
		//	+ "> с объектом-предком <" + ВРЗ.Предок + ">", СтатусСообщения.Информация);
		
		Код = Код + 1;
	КонецЦикла;
	
КонецПроцедуры

Функция   ВычислитьЗначениеАФДля(Поле, Объект, АФ, ПараметрыАФ, ТолькоДляНепосредственных = Ложь, ДопУсловия = "", ИмяРегистра = "СвязиОбъектов_ат")
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ";
	
	Если ТипЗнч(АФ) = Тип("Массив") Тогда
		Индекс = 0;
		Пока Индекс < АФ.Количество() Цикл
			Запрос.Текст = Запрос.Текст + "
				|	" + АФ[Индекс] + "(" + ПараметрыАФ[Индекс] + ") КАК Значение" + Индекс + ",";
			Индекс = Индекс + 1;
		КонецЦикла;
		Запрос.Текст = Лев(Запрос.Текст, СтрДлина(Запрос.Текст) - 1);
	Иначе
		Запрос.Текст = Запрос.Текст + "
			|	" + АФ + "(" + ПараметрыАФ + ") КАК Значение";
	КонецЕсли;
			
	Запрос.Текст = Запрос.Текст + "
		|ИЗ
		|	РегистрСведений." + ИмяРегистра + " КАК СвязиОбъектов
		|ГДЕ
		|	СвязиОбъектов." + Поле + " = &Объект
		|" + ?(ТолькоДляНепосредственных, "И СвязиОбъектов.СсылкаНаКод = 0", "") + "
		|" + ?(ДопУсловия <> "", "И " + ДопУсловия, "");
	Запрос.УстановитьПараметр("Объект", Объект);
	
	ВРЗ = Запрос.Выполнить().Выбрать();
	ВРЗ.Следующий();
	Если ТипЗнч(АФ) = Тип("Массив") Тогда
		М = Новый Массив;
		Индекс = 0;
		Пока Индекс < АФ.Количество() Цикл
			М.Добавить(ВРЗ.Получить(Индекс));
			Индекс = Индекс + 1;
		КонецЦикла;
		Возврат М;
	Иначе
		Возврат ВРЗ.Значение;
	КонецЕсли;
	
КонецФункции


////////////////////////////////////////////////////////////////////////////////
// Процедуры для упрощения взаимодействия

Процедура ДобавитьСвязьСПредком(Объект, Предок, БезТранзакции = Ложь, ТипСвязи = Неопределено, ИмяРегистра = "СвязиОбъектов_ат") Экспорт 
	
	МассивПредков = Новый Массив;
	МассивПредков.Добавить(Предок);
	
	ДобавитьСвязиСПредками(Объект, МассивПредков, БезТранзакции, ТипСвязи, ИмяРегистра);
	
КонецПроцедуры

Процедура УдалитьСвязьСПредком(Объект, Предок, БезТранзакции = Ложь, ИмяРегистра = "СвязиОбъектов_ат") Экспорт 
	
	МассивПредков = Новый Массив;
	МассивПредков.Добавить(Предок);

	УдалитьСвязиСПредками(Объект, МассивПредков, БезТранзакции, ИмяРегистра);
	
КонецПроцедуры 

Процедура ДобавитьСвязиСПредками(Объект, МассивПредков, БезТранзакции = Ложь, ТипСвязи = Неопределено, ИмяРегистра = "СвязиОбъектов_ат") Экспорт
	
	ПредкиОбъекта = ПолучитьПредковОбъекта(Объект, , ИмяРегистра);
	ПотомкиОбъекта = ПолучитьПотомковОбъекта(Объект, , ИмяРегистра);
	
	НовыеПредки = Новый Массив;
	Для Каждого Предок Из МассивПредков Цикл
		Если НЕ Предок = Объект И ПредкиОбъекта.Найти(Предок) = Неопределено И ПотомкиОбъекта.Найти(Предок) = Неопределено Тогда // исключаем дубли и связь объекта с самим собой и потомками
			НовыеПредки.Добавить(Предок);
		КонецЕсли;
	КонецЦикла;
	
	Попытка
		Если Не БезТранзакции Тогда
			НачатьТранзакцию();
		КонецЕсли;
		
		Если НовыеПредки.Количество() > 0 Тогда
			ДобавитьСвязиСПредкамиОбъекта(Объект, НовыеПредки, ПотомкиОбъекта, ТипСвязи, ИмяРегистра);
		КонецЕсли;
			
		Если Не БезТранзакции Тогда
			ЗафиксироватьТранзакцию();
		КонецЕсли;
	Исключение
		Сообщить("СвязиОбъектов: " + ОписаниеОшибки(), СтатусСообщения.Важное);
		Если Не БезТранзакции Тогда
			ОтменитьТранзакцию();
		Иначе
			ВызватьИсключение;
		КонецЕсли;
	КонецПопытки;
	
КонецПроцедуры

Процедура УдалитьСвязиСПредками(Объект, МассивПредков, БезТранзакции = Ложь, ИмяРегистра = "СвязиОбъектов_ат") Экспорт 
	
	Если МассивПредков.Количество() > 0 Тогда
		ПотомкиОбъекта = ПолучитьПотомковОбъекта(Объект, , ИмяРегистра);
		
		Попытка
			Если Не БезТранзакции Тогда
				НачатьТранзакцию();
			КонецЕсли;
			
			УдалитьСвязиСПредкамиОбъекта(Объект, МассивПредков, ПотомкиОбъекта, ИмяРегистра);
			
			Если Не БезТранзакции Тогда
				ЗафиксироватьТранзакцию();
			КонецЕсли;
		Исключение
			Сообщить("СвязиОбъектов: " + ОписаниеОшибки(), СтатусСообщения.Важное);
			Если Не БезТранзакции Тогда
				ОтменитьТранзакцию();
			Иначе
				ВызватьИсключение;
			КонецЕсли;
		КонецПопытки;
	КонецЕсли;
	
КонецПроцедуры

Процедура ДобавитьСвязиСПотомками(Объект, МассивПотомков, БезТранзакции = Ложь, ТипСвязи = Неопределено, ИмяРегистра = "СвязиОбъектов_ат") Экспорт 
	
	ПредкиОбъекта = ПолучитьПредковОбъекта(Объект, , ИмяРегистра);
	ПотомкиОбъекта = ПолучитьПотомковОбъекта(Объект, , ИмяРегистра);
	
	НовыеПотомки = Новый Массив;
	
	Для Каждого Потомок Из МассивПотомков Цикл
		Если НЕ Потомок = Объект И ПотомкиОбъекта.Найти(Потомок) = Неопределено И ПредкиОбъекта.Найти(Потомок) = Неопределено Тогда // исключаем дубли и связь объекта с самим собой и потомками
			НовыеПотомки.Добавить(Потомок);
		КонецЕсли;
	КонецЦикла;
	
	Попытка
		Если Не БезТранзакции Тогда
			НачатьТранзакцию();
		КонецЕсли;
		
		МассивИзОбъекта = Новый Массив;
		МассивИзОбъекта.Добавить(Объект);

		Для Каждого НовыйПотомок Из НовыеПотомки Цикл
			ДобавитьСвязиСПредкамиОбъекта(НовыйПотомок, МассивИзОбъекта, , ТипСвязи, ИмяРегистра);
		КонецЦикла;
		
		Если Не БезТранзакции Тогда
			ЗафиксироватьТранзакцию();
		КонецЕсли;
	Исключение
		Сообщить("СвязиОбъектов: " + ОписаниеОшибки(), СтатусСообщения.Важное);
		Если Не БезТранзакции Тогда
			ОтменитьТранзакцию();
		Иначе
			ВызватьИсключение;
		КонецЕсли;
	КонецПопытки;
	
КонецПроцедуры

Процедура УдалитьСвязиСПотомками(Объект, МассивПотомков, БезТранзакции = Ложь, ИмяРегистра = "СвязиОбъектов_ат") Экспорт 
	
	Попытка
		Если Не БезТранзакции Тогда
			НачатьТранзакцию();
		КонецЕсли;
		
		МассивИзОбъекта = Новый Массив;
		МассивИзОбъекта.Добавить(Объект);

		Для Каждого УдаляемыйПотомок Из МассивПотомков Цикл
			УдалитьСвязиСПредкамиОбъекта(УдаляемыйПотомок, МассивИзОбъекта, ИмяРегистра);
		КонецЦикла;
		
		Если Не БезТранзакции Тогда
			ЗафиксироватьТранзакцию();
		КонецЕсли;
	Исключение
		Сообщить("СвязиОбъектов: " + ОписаниеОшибки(), СтатусСообщения.Важное);
		Если Не БезТранзакции Тогда
			ОтменитьТранзакцию();
		Иначе
			ВызватьИсключение;
		КонецЕсли;
	КонецПопытки;
	
КонецПроцедуры
