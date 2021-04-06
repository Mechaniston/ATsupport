﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ОбъектАвторизации", ПараметрКоманды);
	
	Попытка
		ОткрытьФорму(
			"Справочник.ВнешниеПользователи.ФормаОбъекта",
			ПараметрыФормы,
			ПараметрыВыполненияКоманды.Источник,
			ПараметрыВыполненияКоманды.Уникальность,
			ПараметрыВыполненияКоманды.Окно);
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		Если Найти(ПодробноеПредставлениеОшибки(ИнформацияОбОшибке),
		         "ВызватьИсключение ОписаниеОшибкиКакПредупреждения") > 0 Тогда
			Предупреждение(КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
		Иначе
			ВызватьИсключение;
		КонецЕсли;
	КонецПопытки;
	
КонецПроцедуры
