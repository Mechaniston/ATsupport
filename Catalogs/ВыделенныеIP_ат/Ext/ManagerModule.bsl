﻿
Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	//Представление = Строка(Данные.Ссылка.Наименование + " ( " + Данные.Ссылка.IP + " "+Данные.Ссылка.ВиртуальнаяСеть + ")" );
	Представление = Данные.Ссылка.ПредставлениеIP + " (" + Данные.Ссылка.ВиртуальнаяСеть + ")";         
	
КонецПроцедуры
