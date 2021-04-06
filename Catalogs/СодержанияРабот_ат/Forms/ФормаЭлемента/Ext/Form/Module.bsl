﻿
&НаКлиенте
Процедура СвойстваЭкземпляровПродуктовСвойствоНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Элементы.СвойстваЭкземпляровПродуктов.ТекущиеДанные.ТипПродукта) Тогда
		
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = ПолучитьСвойстваПоТипуПродукта(Элементы.СвойстваЭкземпляровПродуктов.ТекущиеДанные.ТипПродукта);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция   ПолучитьСвойстваПоТипуПродукта(ТипПродукта)
	
	ИмяРегистраСпецификацииПродуктов = УчетПродуктов_ат.ПолучитьИмяРегистраСпецификацииЭкземпляраПродукта(ТипПродукта);
	
	Свойства = Новый СписокЗначений;
	
	Для Каждого Ресурс Из Метаданные.РегистрыСведений[ИмяРегистраСпецификацииПродуктов].Ресурсы Цикл
		
		Свойства.Добавить(Ресурс.Имя, Ресурс.Синоним);
		
	КонецЦикла;
	
	Возврат Свойства;
	
КонецФункции

&НаСервере
Процедура ПодготовитьВыборЗначенияСвойстваПродукта(Свойство, ТипПродукта)
	
	Если ЗначениеЗаполнено(Свойство) Тогда
		
		ИмяРегистраСпецификацииПродуктов = УчетПродуктов_ат.ПолучитьИмяРегистраСпецификацииЭкземпляраПродукта(ТипПродукта);
		
		Если НЕ ПустаяСтрока(ИмяРегистраСпецификацииПродуктов) Тогда
			
			Ресурс = Метаданные.РегистрыСведений[ИмяРегистраСпецификацииПродуктов].Ресурсы[Свойство];
			Типы = Ресурс.Тип.Типы();
			
			ОписаниеТипов = Новый ОписаниеТипов(Типы);
			
			Элементы.СвойстваЭкземпляровПродуктовЗначениеСвойства.ОграничениеТипа = ОписаниеТипов;
			Элементы.СвойстваЭкземпляровПродуктовЗначениеСвойства.ПараметрыВыбора = Ресурс.ПараметрыВыбора;
						
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СвойстваЭкземпляровПродуктовПриАктивизацииЯчейки(Элемент)
	
	Если Элемент.ТекущийЭлемент.Имя = "СвойстваЭкземпляровПродуктовЗначениеСвойства" Тогда
		
		ПодготовитьВыборЗначенияСвойстваПродукта(Элементы.СвойстваЭкземпляровПродуктов.ТекущиеДанные.Свойство, Элементы.СвойстваЭкземпляровПродуктов.ТекущиеДанные.ТипПродукта);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СвойстваЭкземпляровПродуктовТипПродуктаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.СвойстваЭкземпляровПродуктов.ТекущиеДанные;
	
	ТекущиеДанные.Свойство = "";
	ТекущиеДанные.ЗначениеСвойства = Неопределено;
	
КонецПроцедуры
