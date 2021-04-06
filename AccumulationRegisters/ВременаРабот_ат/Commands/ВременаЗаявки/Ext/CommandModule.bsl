﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если ТипЗнч(ПараметрКоманды) = Тип("ДокументСсылка.Заявка_ат") Тогда
		
		Заявка = ПараметрКоманды;
		
	Иначе
		
		Заявка = ПолучитьЗаявку(ПараметрКоманды);
		
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура("Отбор", Новый Структура("Заявка", Заявка));
	ОткрытьФорму("РегистрНакопления.ВременаРабот_ат.ФормаСписка", ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность,
		ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
КонецПроцедуры

Функция   ПолучитьЗаявку(Ссылка)
	
	Возврат Ссылка.Заявка;
	
КонецФункции