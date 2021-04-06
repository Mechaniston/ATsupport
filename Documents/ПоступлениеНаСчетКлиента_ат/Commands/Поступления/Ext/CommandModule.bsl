﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если 	ТипЗнч(ПараметрКоманды) = Тип("СправочникСсылка.Контрагенты_ат") Тогда
		
		ПараметрИмя = "Клиент";
		
	ИначеЕсли 	ТипЗнч(ПараметрКоманды) = Тип("СправочникСсылка.Договоры_ат") Тогда
		
		ПараметрИмя = "Ссылка.РасшифровкаПлатежа.СчетНаОплату.Договор";
		
	ИначеЕсли 	ТипЗнч(ПараметрКоманды) = Тип("ДокументСсылка.СчетНаОплату_ат") Тогда
		
		ПараметрИмя = "Ссылка.РасшифровкаПлатежа.СчетНаОплату";
		
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
	
	ОткрытьФорму("Документ.ПоступлениеНаСчетКлиента_ат.ФормаСписка", ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно,
		ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
КонецПроцедуры
