﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если 	ТипЗнч(ПараметрКоманды) = Тип("ДокументСсылка.Заявка_ат") Тогда
		
		ПараметрИмя = "Заявка";
		
	ИначеЕсли 	ТипЗнч(ПараметрКоманды) = Тип("ДокументСсылка.Задание_ат") Тогда
		
		ПараметрИмя = "Задание";
		
	ИначеЕсли 	ТипЗнч(ПараметрКоманды) = Тип("ДокументСсылка.Согласование_ат") Тогда
		
		ПараметрИмя = "Согласование";
		
	ИначеЕсли 	ТипЗнч(ПараметрКоманды) = Тип("ДокументСсылка.ФиксацияРабот_ат") Тогда
		
		ПараметрИмя = "ФиксацияРабот";
		
	ИначеЕсли 	ТипЗнч(ПараметрКоманды) = Тип("ДокументСсылка.СчетНаОплату_ат") Тогда
		
		ПараметрИмя = "Счет";
		
	ИначеЕсли 	ТипЗнч(ПараметрКоманды) = Тип("ДокументСсылка.Реализация_ат") Тогда
		
		ПараметрИмя = "Реализация";
		
	ИначеЕсли 	ТипЗнч(ПараметрКоманды) = Тип("ДокументСсылка.ПоступлениеНаСчетКлиента_ат") Тогда
		
		ПараметрИмя = "Поступление";
		
	ИначеЕсли 	ТипЗнч(ПараметрКоманды) = Тип("ДокументСсылка.СписаниеСоСчетаКлиента_ат") Тогда
		
		ПараметрИмя = "Списание";
		
	Иначе
		
		ПараметрИмя = "";
		
	КонецЕсли;
	
	Если Не ПустаяСтрока(ПараметрИмя) Тогда
		
		фиксНастройки = Новый НастройкиКомпоновкиДанных;
		
		эОтбор = фиксНастройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		эОтбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(ПараметрИмя);
		эОтбор.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		эОтбор.ПравоеЗначение = ПараметрКоманды;
		эОтбор.Использование = Истина;
		
		//эОтбор.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ФиксированныеНастройки", фиксНастройки);
		//ПараметрыФормы = Новый Структура("Отбор", Новый Структура(ПараметрИмя, ПараметрКоманды));
		ПараметрыФормы.Вставить("НеСохранятьПользовательскиеНастройки", Истина);
		
	Иначе
		
		ПараметрыФормы = Новый Структура();
		
	КонецЕсли;
	
	ОткрытьФорму("РегистрСведений.КосвенныеСвязиЗаданий_ат.ФормаСписка", ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно,
		ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
КонецПроцедуры
