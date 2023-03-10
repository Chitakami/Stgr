
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	Если ЕстьСвободныеМеста() Тогда
		Движения.СвободныеМеста.Записывать = Истина;
		Движения.СвободныеМеста.Очистить();
		Для Каждого ТекущаяСтрока Из ТаблицаЗаявка  Цикл
			Движение = Движения.СвободныеМеста.Добавить();
			Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
	        Движение.Курс = ТекущаяСтрока.Курс;
	        Движение.КоличествоМест = 1;
			Движение.Период = Дата;
			Движение.Класс = ПолучениеКлассаИзРасписания();
		КонецЦикла;	 
	Иначе
		Отказ = Истина;
	КонецЕсли;
КонецПроцедуры

Функция ЕстьСвободныеМеста()
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ЗаявкаТаблицаЗаявка.Ссылка КАК Заявка,
	               |	ЗаявкаТаблицаЗаявка.Курс КАК Курс,
	               |	ЕСТЬNULL(СвободныеМестаОстатки.КоличествоМестОстаток, 0) КАК КоличествоМест
	               |ИЗ
	               |	Документ.Заявка.ТаблицаЗаявка КАК ЗаявкаТаблицаЗаявка
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.СвободныеМеста.Остатки КАК СвободныеМестаОстатки
	               |		ПО ЗаявкаТаблицаЗаявка.Курс = СвободныеМестаОстатки.Курс
	               |ГДЕ
	               |	ЗаявкаТаблицаЗаявка.Ссылка = &Ссылка";

	Запрос.УстановитьПараметр("Ссылка", Ссылка);
 
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	Для каждого Строка из РезультатЗапроса Цикл 
		Если Строка.КоличествоМест <= 0 Тогда
			Сообщить("К сожалению, нет свободных мест для курса """ + Строка.Курс + """");
			Возврат Ложь;	
		КонецЕсли;
	КонецЦикла;
	
	Возврат Истина;
КонецФункции 

функция ПолучениеКлассаИзРасписания ()
	Запрос = Новый Запрос;
	
	Запрос.Текст = "ВЫБРАТЬ
	|	РасписаниеТаблРасписание.Ссылка КАК Ссылка,
	|	ЗаявкаТаблЗаявка.Курс КАК Курс,
	|	РасписаниеТаблРасписание.Класс КАК Класс
	|ИЗ
	|	Документ.Заявка.ТаблицаЗаявка КАК ЗаявкаТаблЗаявка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Расписание.ТаблицаРасписание КАК РасписаниеТаблРасписание
	|		ПО ЗаявкаТаблЗаявка.Курс = РасписаниеТаблРасписание.Курс
	|ГДЕ
	|	ЗаявкаТаблЗаявка.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	Результат = РезультатЗапроса.Выгрузить();
	Возврат Результат[0].Класс;
КонецФункции

