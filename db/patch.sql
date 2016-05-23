----------------------------------------
-- BEGIN BLOCK: 1
----------------------------------------
create table db_version (
	version integer unique not null
);

create table page (
	page_id text primary key,
	parent_page_id text references page on delete set null on update cascade,
	has_content boolean not null default true,
	seq_nr integer not null,
	teacher_topic boolean default false,
	deleted boolean default false
);

create table content (
	page_id text references page on delete cascade on update cascade,
	lang text not null,
	title text not null,
	content text,
	version integer not null,
	tag text,
	saved_by text,
	saved timestamp not null default now()
);

create table template (
	template_id serial,
	name text not null,
	content text not null
);

insert into db_version (version) values (1);
----------------------------------------
-- END BLOCK: 1
----------------------------------------

----------------------------------------
-- BEGIN BLOCK: 2
----------------------------------------
alter table page rename column has_content to is_folder;
update page set is_folder = not is_folder;

alter table content add column tag_ts timestamp;

UPDATE db_version SET version = 2;
----------------------------------------
-- END BLOCK: 2
----------------------------------------


----------------------------------------
-- BEGIN BLOCK: 3
----------------------------------------

-- Create initial help text structure
delete from page;

-- Overview
insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('_core', null, true, 1);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_core', 'sv', '�versikt', '<h1>�versikt</h1>', 1, 'mango');

-- Start page
insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('f_core.startpage', null, true, 2);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('f_core.startpage', 'sv', 'Startsidan', null, 1, 'mango');
insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('_core.startpage', 'f_core.startpage', true, 1);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_core.startpage', 'sv', 'Startsidan', '<h1>Startsidan</h1>', 1, 'mango');
insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('_core.startpage.config', 'f_core.startpage', true, 2);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_core.startpage.config', 'sv', 'Konfigurera', '<h1>Konfigurera startsidan</h1>', 1, 'mango');
insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('_core.startpage.config.shortcuts', 'f_core.startpage', true, 3);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_core.startpage.config.shortcuts', 'sv', 'Genv�gar', '<h1>Konfigurera genv�gar</h1>', 1, 'mango');

-- Courses
insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('f_core.course', null, true, 3);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('f_core.course', 'sv', 'Aktiviteter', null, 1, 'mango');
insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('_core.course.overview', 'f_core.course', true, 1);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_core.course.overview', 'sv', '�versikt', '<h1>�versikt aktiviteter</h1>', 1, 'mango');
insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('_core.course.mycurrentcourses', 'f_core.course', true, 2);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_core.course.mycurrentcourses', 'sv', 'P�g�ende aktiviteter', '<h1>P�g�ende aktiviteter</h1>', 1, 'mango');
insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('_core.course.myapprovedcourses', 'f_core.course', true, 3);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_core.course.myapprovedcourses', 'sv', 'Godk�nda aktiviteter', '<h1>Godk�nda aktiviteter</h1>', 1, 'mango');
insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('_core.course.mycourses', 'f_core.course', true, 4);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_core.course.mycourses', 'sv', 'Alla aktiviteter', '<h1>Alla aktiviteter</h1>', 1, 'mango');
insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('_core.course.courseinfo', 'f_core.course', true, 5);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_core.course.courseinfo', 'sv', 'Information om aktivitet', '<h1>Information om aktivitet</h1>', 1, 'mango');
insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('_core.course.catalog', 'f_core.course', true, 6);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_core.course.catalog', 'sv', 'Katalogen', '<h1>Katalogen</h1>', 1, 'mango');
insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('_core.course.catalog.courseinfo', 'f_core.course', true, 7);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_core.course.catalog.courseinfo', 'sv', 'Information om aktivitet i katalogen', '<h1>Information om aktivitet i katalogen</h1>', 1, 'mango');


-- Inside a course
insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('f_course', null, true, 4);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('f_course', 'sv', 'Inne i en aktivitet', null, 1, 'mango');
insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('_course.startpage', 'f_course', true, 1);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_course.startpage', 'sv', '�versikt', '<h1>�versikt</h1>', 1, 'mango');

insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('_course.results.objectives', 'f_course', true, 2);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_course.results.objectives', 'sv', 'Kursm�l och framsteg', '<h1>Kursm�l och framsteg</h1>', 1, 'mango');

insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('_course.lesson', 'f_course', true, 3);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_course.lesson', 'sv', 'Inneh�ll', '<h1>Inneh�ll</h1>', 1, 'mango');

insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('f_course.docsandfiles', 'f_course', true, 4);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('f_course.docsandfiles', 'sv', 'Dokument', null, 1, 'mango');
insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('_course.docsandfiles', 'f_course.docsandfiles', true, 1);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_course.docsandfiles', 'sv', 'Dokument', '<h1>Dokument</h1>', 1, 'mango');
insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('_course.docsandfiles.info', 'f_course.docsandfiles', true, 2);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_course.docsandfiles.info', 'sv', 'Information om dokument', '<h1>Information om dokument</h1>', 1, 'mango');
insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('_course.docsandfiles.comment', 'f_course.docsandfiles', true, 3);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_course.docsandfiles.comment', 'sv', 'Kommentera ett dokument', '<h1>Kommentera ett dokument</h1>', 1, 'mango');

insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('f_course.faq', 'f_course', true, 5);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('f_course.faq', 'sv', 'Vanliga fr�gor', null, 1, 'mango');
insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('_course.faq', 'f_course.faq', true, 1);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_course.faq', 'sv', 'Vanliga fr�gor', '<h1>Vanliga fr�gor</h1>', 1, 'mango');
insert into page (page_id, parent_page_id, is_folder, seq_nr, teacher_topic)
	values ('_course.faq.create', 'f_course.faq', true, 2, true);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_course.faq.create', 'sv', 'Skapa vanlig fr�ga', '<h1>Skapa vanlig fr�ga</h1>', 1, 'mango');
insert into page (page_id, parent_page_id, is_folder, seq_nr, teacher_topic)
	values ('_course.faq.edit', 'f_course.faq', true, 3, true);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_course.faq.edit', 'sv', 'Redigera vanlig fr�ga', '<h1>Redigera vanlig fr�ga</h1>', 1, 'mango');


insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('_course.tests', 'f_course', true, 6);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_course.tests', 'sv', 'Tester', '<h1>Tester</h1>', 1, 'mango');

insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('_course.questionnaire', 'f_course', true, 7);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_course.questionnaire', 'sv', 'Enk�ter', '<h1>Enk�ter</h1>', 1, 'mango');

insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('_course.reportsubmissions', 'f_course', true, 8);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_course.reportsubmissions', 'sv', 'Inl�mningsuppgifter', '<h1>Inl�mningsuppgifter</h1>', 1, 'mango');

insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('_course.results.summary', 'f_course', true, 9);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_course.results.summary', 'sv', 'Statistik', '<h1>Statistik</h1>', 1, 'mango');

insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('_course.results.portfolio', 'f_course', true, 10);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_course.results.portfolio', 'sv', 'Portfolio', '<h1>Portfolio</h1>', 1, 'mango');

insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('f_course.noticeboard', 'f_course', true, 11);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('f_course.noticeboard', 'sv', 'Anslagstavla', null, 1, 'mango');
insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('_course.noticeboard', 'f_course.noticeboard', true, 1);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_course.noticeboard', 'sv', 'Anslagstavla', '<h1>Anslagstavla</h1>', 1, 'mango');
insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('_course.noticeboard.show', 'f_course.noticeboard', true, 2);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_course.noticeboard.show', 'sv', 'Visa anslag', '<h1>Visa anslag</h1>', 1, 'mango');
insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('_course.noticeboard.create', 'f_course.noticeboard', true, 3);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_course.noticeboard.create', 'sv', 'Skapa anslag', '<h1>Skapa anslag</h1>', 1, 'mango');
insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('_course.noticeboard.edit', 'f_course.noticeboard', true, 4);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_course.noticeboard.edit', 'sv', 'Redigera anslag', '<h1>Redigera anslag</h1>', 1, 'mango');

insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('_course.participants', 'f_course', true, 12);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_course.participants', 'sv', 'Deltagare', '<h1>Deltagare</h1>', 1, 'mango');

insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('f_course.projectgroups', 'f_course', true, 13);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('f_course.projectgroups', 'sv', 'Projektgrupper', null, 1, 'mango');
insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('_course.projectgroups.list', 'f_course.projectgroups', true, 1);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_course.projectgroups.list', 'sv', 'Projektgrupper', '<h1>Projektgrupper</h1>', 1, 'mango');
insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('_course.projectgroups.new', 'f_course.projectgroups', true, 2);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_course.projectgroups.new', 'sv', 'Skapa projektgrupp', '<h1>Skapa projektgrupp</h1>', 1, 'mango');
insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('_course.projectgroups.edit', 'f_course.projectgroups', true, 3);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_course.projectgroups.edit', 'sv', 'Redigera projektgrupp', '<h1>Redigera projektgrupp</h1>', 1, 'mango');
insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('_course.projectgroups.overview', 'f_course.projectgroups', true, 4);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_course.projectgroups.overview', 'sv', '�versikt', '<h1>�versikt projektgrupp</h1>', 1, 'mango');
insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('_course.projectgroups.todo', 'f_course.projectgroups', true, 5);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_course.projectgroups.todo', 'sv', 'Uppgifter', '<h1>Uppgifter</h1>', 1, 'mango');
insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('_course.projectgroups.ownsite', 'f_course.projectgroups', true, 6);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_course.projectgroups.ownsite', 'sv', 'Egen sida', '<h1>Egen sida</h1>', 1, 'mango');

insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('f_course.communication.discuss', 'f_course', true, 14);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('f_course.communication.discuss', 'sv', 'Diskussionsforum', null, 1, 'mango');
insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('_course.communication.discuss', 'f_course.communication.discuss', true, 1);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_course.communication.discuss', 'sv', 'Diskussionsforum', '<h1>Diskussionsforum</h1>', 1, 'mango');
insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('_course.communication.discuss.subjects', 'f_course.communication.discuss', true, 2);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_course.communication.discuss.subjects', 'sv', '�mnen', '<h1>�mnen</h1>', 1, 'mango');
insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('_course.communication.discuss.new-forum', 'f_course.communication.discuss', true, 3);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_course.communication.discuss.new-forum', 'sv', 'Nytt forum', '<h1>Nytt forum</h1>', 1, 'mango');
insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('_course.communication.discuss.edit-forum', 'f_course.communication.discuss', true, 4);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_course.communication.discuss.edit-forum', 'sv', 'Redigera forum', '<h1>Redigera forum</h1>', 1, 'mango');
insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('_course.communication.discuss.new-subject', 'f_course.communication.discuss', true, 5);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_course.communication.discuss.new-subject', 'sv', 'Nytt �mne', '<h1>Nytt �mne</h1>', 1, 'mango');
insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('_course.communication.discuss.edit-subject', 'f_course.communication.discuss', true, 6);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_course.communication.discuss.edit-subject', 'sv', 'Redigera �mne', '<h1>Redigera �mne</h1>', 1, 'mango');
insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('_course.communication.discuss.posts', 'f_course.communication.discuss', true, 7);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_course.communication.discuss.posts', 'sv', 'Inl�gg', '<h1>Inl�gg</h1>', 1, 'mango');
insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('_course.communication.discuss.edit-post', 'f_course.communication.discuss', true, 8);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_course.communication.discuss.edit-post', 'sv', 'Redigera inl�gg', '<h1>Redigera inl�gg</h1>', 1, 'mango');
insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('_course.communication.discuss.new-post', 'f_course.communication.discuss', true, 9);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_course.communication.discuss.new-post', 'sv', 'Nytt inl�gg', '<h1>Nytt inl�gg</h1>', 10, 'mango');
insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('_course.communication.discuss.attachment', 'f_course.communication.discuss', true, 11);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_course.communication.discuss.attachment', 'sv', 'Bifoga fil', '<h1>Bifoga fil</h1>', 1, 'mango');
insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('_course.communication.discuss.preview', 'f_course.communication.discuss', true, 12);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_course.communication.discuss.preview', 'sv', 'F�rhandsvisa inl�gg', '<h1>F�rhandsvisa inl�gg</h1>', 1, 'mango');

insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('_course.communication.question-ask', 'f_course', true, 15);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_course.communication.question-ask', 'sv', 'St�ll fr�gor', '<h1>St�ll fr�gor</h1>', 1, 'mango');

insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('_course.communication.pim', 'f_course', true, 16);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_course.communication.pim', 'sv', 'Skicka PIM', '<h1>Skicka PIM</h1>', 1, 'mango');

insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('_course.communication.chat', 'f_course', true, 17);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_course.communication.chat', 'sv', 'Chat', '<h1>Chat</h1>', 1, 'mango');


-- TEACHER
insert into page (page_id, parent_page_id, is_folder, seq_nr, teacher_topic)
	values ('f_course.communication.sendmessages', 'f_course', true, 18, true);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('f_course.communication.sendmessages', 'sv', 'Skicka meddelande', null, 1, 'mango');
insert into page (page_id, parent_page_id, is_folder, seq_nr, teacher_topic)
	values ('_course.communication.sendmessages.form', 'f_course.communication.sendmessages', true, 1, true);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_course.communication.sendmessages.form', 'sv', 'Skicka meddelande', '<h1>Skicka meddelande</h1>', 1, 'mango');
insert into page (page_id, parent_page_id, is_folder, seq_nr, teacher_topic)
	values ('_course.communication.sendmessages.confirm', 'f_course.communication.sendmessages', true, 2, true);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_course.communication.sendmessages.confirm', 'sv', 'F�rhandsvisa', '<h1>F�rhandsvisa</h1>', 1, 'mango');
insert into page (page_id, parent_page_id, is_folder, seq_nr, teacher_topic)
	values ('_course.communication.sendmessages.result', 'f_course.communication.sendmessages', true, 3, true);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_course.communication.sendmessages.result', 'sv', 'Meddelande skickat', '<h1>Meddelande skickat</h1>', 1, 'mango');
insert into page (page_id, parent_page_id, is_folder, seq_nr, teacher_topic)
	values ('_course.communication.sendmessages.mail-log', 'f_course.communication.sendmessages', true, 4, true);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_course.communication.sendmessages.mail-log', 'sv', 'Meddelandelogg', '<h1>Meddelandelogg</h1>', 1, 'mango');
insert into page (page_id, parent_page_id, is_folder, seq_nr, teacher_topic)
	values ('_course.communication.sendmessages.template-form', 'f_course.communication.sendmessages', true, 5, true);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_course.communication.sendmessages.template-form', 'sv', 'Mallar', '<h1>Mallar</h1>', 1, 'mango');
insert into page (page_id, parent_page_id, is_folder, seq_nr, teacher_topic)
	values ('_course.communication.sendmessages.attachment-form', 'f_course.communication.sendmessages', true, 6, true);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_course.communication.sendmessages.attachment-form', 'sv', 'Bifoga filer', '<h1>Bifoga filer</h1>', 1, 'mango');

insert into page (page_id, parent_page_id, is_folder, seq_nr, teacher_topic)
	values ('_course.preferences', 'f_course', true, 19, true);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_course.preferences', 'sv', 'Inst�llningar', '<h1>Inst�llningar</h1>', 1, 'mango');

insert into page (page_id, parent_page_id, is_folder, seq_nr, teacher_topic)
	values ('_course.projectgroups.teacherlist', 'f_course', true, 20, true);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_course.projectgroups.teacherlist', 'sv', 'Projektgrupper f�r l�rare', '<h1>Projektgrupper f�r l�rare</h1>', 1, 'mango');

insert into page (page_id, parent_page_id, is_folder, seq_nr, teacher_topic)
	values ('f_course.communication.question', 'f_course', true, 21, true);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('f_course.communication.question', 'sv', 'Besvara fr�gor', null, 1, 'mango');
insert into page (page_id, parent_page_id, is_folder, seq_nr, teacher_topic)
	values ('_course.communication.question-list', 'f_course.communication.question', true, 1, true);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_course.communication.question-list', 'sv', 'Lista obesvarade fr�gor', '<h1>Lista obesvarade fr�gor</h1>', 1, 'mango');
insert into page (page_id, parent_page_id, is_folder, seq_nr, teacher_topic)
	values ('_course.communication.question-reply', 'f_course.communication.question', true, 2, true);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_course.communication.question-reply', 'sv', 'Skriv svar', '<h1>Skriv svar</h1>', 1, 'mango');

-- Personal
insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('f_personal', null, true, 5);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('f_personal', 'sv', 'Personligt', null, 1, 'mango');
insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('_personal.overview', 'f_personal', true, 1);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_personal.overview', 'sv', '�versikt', '<h1>�versikt personligt</h1>', 1, 'mango');

insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('f_personal.information', 'f_personal', true, 2);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('f_personal.information', 'sv', 'Personuppgifter', null, 1, 'mango');
insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('_personal.information', 'f_personal.information', true, 1);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_personal.information', 'sv', 'Personuppgifter', '<h1>Personuppgifter</h1>', 1, 'mango');
insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('_personal.information.edit', 'f_personal.information', true, 2);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_personal.information.edit', 'sv', 'Redigera personuppgifter', '<h1>Redigera personuppgifter</h1>', 1, 'mango');
insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('_personal.information.image-upload', 'f_personal.information', true, 3);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_personal.information.image-upload', 'sv', 'Ladda upp personlig bild', '<h1>Ladda upp personlig bild</h1>', 1, 'mango');

insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('_personal.preferences', 'f_personal', true, 5);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_personal.preferences', 'sv', 'Inst�llningar', '<h1>Inst�llningar</h1>', 1, 'mango');

insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('f_personal.mydocuments', 'f_personal', true, 6);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('f_personal.mydocuments', 'sv', 'Dokument', null, 1, 'mango');
insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('_personal.mydocuments', 'f_personal.mydocuments', true, 1);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_personal.mydocuments', 'sv', 'Dokument', '<h1>Dokument</h1>', 1, 'mango');
insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('_personal.mydocuments.info', 'f_personal.mydocuments', true, 2);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_personal.mydocuments.info', 'sv', 'Information om dokument', '<h1>Information om dokument</h1>', 1, 'mango');
insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('_personal.mydocuments.comment', 'f_personal.mydocuments', true, 3);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_personal.mydocuments.comment', 'sv', 'Kommentera dokument', '<h1>Kommentera dokument</h1>', 1, 'mango');

insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('f_personal.km.profile', 'f_personal', true, 9);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('f_personal.km.profile', 'sv', 'Kompetensprofil', null, 1, 'mango');
insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('_personal.km.profile', 'f_personal.km.profile', true, 1);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_personal.km.profile', 'sv', '�versikt', '<h1>�versikt kompetensprofil</h1>', 1, 'mango');
insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('_personal.km.competencies.edit', 'f_personal.km.profile', true, 2);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_personal.km.competencies.edit', 'sv', 'Redigera kompetenser', '<h1>Redigera kompetenser</h1>', 1, 'mango');
insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('_personal.km.profession.edit', 'f_personal.km.profile', true, 3);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_personal.km.profession.edit', 'sv', 'Redigera befattning', '<h1>Redigera befattning</h1>', 1, 'mango');
insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('_personal.km.externalcoursesgiver.edit', 'f_personal.km.profile', true, 4);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_personal.km.externalcoursesgiver.edit', 'sv', 'Redigera org. kunskapsaktiviteter', '<h1>Redigera organisationens kunskapsaktiviteter</h1>', 1, 'mango');
insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('_personal.km.externalcourses.edit', 'f_personal.km.profile', true, 5);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_personal.km.externalcourses.edit', 'sv', 'Redigera egna kunskapsaktiviteter', '<h1>Redigera egna kunskapsaktiviteter</h1>', 1, 'mango');
insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('_personal.km.externalcourse.edit', 'f_personal.km.profile', true, 6);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_personal.km.externalcourse.edit', 'sv', 'Redigera kunskapsaktivitet', '<h1>Redigera kunskapsaktivitet</h1>', 1, 'mango');

insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('_personal.cv', 'f_personal', true, 15);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_personal.cv', 'sv', 'CV', '<h1>CV</h1>', 1, 'mango');


-- Communication
insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('f_communication', null, true, 6);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('f_communication', 'sv', 'Kommunikation', null, 1, 'mango');
insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('_communication.overview', 'f_communication', true, 1);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_communication.overview', 'sv', '�versikt', '<h1>�versikt kommunikation</h1>', 1, 'mango');

insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('f_communication.pim', 'f_communication', true, 2);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('f_communication.pim', 'sv', 'PIM', null, 1, 'mango');
insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('_communication.pim.listInbox', 'f_communication.pim', true, 1);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_communication.pim.listInbox', 'sv', 'PIM Inbox', '<h1>PIM Inbox</h1>', 1, 'mango');
insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('_communication.pim.listOutbox', 'f_communication.pim', true, 2);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_communication.pim.listOutbox', 'sv', 'PIM Utbox', '<h1>PIM Utbox</h1>', 1, 'mango');
insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('_communication.pim.write', 'f_communication.pim', true, 3);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_communication.pim.write', 'sv', 'Skriva PIM', '<h1>Skriva PIM</h1>', 1, 'mango');
insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('_communication.pim.search', 'f_communication.pim', true, 4);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_communication.pim.search', 'sv', 'S�k PIM', '<h1>S�k PIM</h1>', 1, 'mango');


insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('f_communication.latestnews', 'f_communication', true, 3);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('f_communication.latestnews', 'sv', 'Senaste nytt', null, 1, 'mango');
insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('_communication.latestnews', 'f_communication.latestnews', true, 1);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_communication.latestnews', 'sv', 'Senaste nytt', '<h1>Senaste nytt</h1>', 1, 'mango');
insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('_communication.latestnews.discussBlacklist.edit', 'f_communication.latestnews', true, 2);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_communication.latestnews.discussBlacklist.edit', 'sv', 'Inst�llningar', '<h1>Inst�llningar Senaste nytt</h1>', 1, 'mango');

insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('f_communication.contactlist', 'f_communication', true, 4);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('f_communication.contactlist', 'sv', 'Kontaktlista', null, 1, 'mango');
insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('_communication.contactlist', 'f_communication.contactlist', true, 1);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_communication.contactlist', 'sv', 'Kontaktlista', '<h1>Kontaktlista</h1>', 1, 'mango');
insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('_communication.contactlist.add', 'f_communication.contactlist', true, 2);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_communication.contactlist.add', 'sv', 'L�gg till kontakt', '<h1>L�gg till kontakt</h1>', 1, 'mango');
insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('_communication.contactlist.search', 'f_communication.contactlist', true, 3);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_communication.contactlist.search', 'sv', 'S�k kontakter', '<h1>S�k kontakter</h1>', 1, 'mango');

insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('f_communication.entranceMessages', 'f_communication', true, 5);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('f_communication.entranceMessages', 'sv', 'Information', null, 1, 'mango');
insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('_communication.entranceMessages.list', 'f_communication.entranceMessages', true, 1);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_communication.entranceMessages.list', 'sv', 'Lista meddelanden', '<h1>Lista meddelanden</h1>', 1, 'mango');
insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('_communication.entranceMessages.show', 'f_communication.entranceMessages', true, 2);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_communication.entranceMessages.show', 'sv', 'Visa meddelande', '<h1>Visa meddelande</h1>', 1, 'mango');
insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('_communication.entranceMessages.create', 'f_communication.entranceMessages', true, 3);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_communication.entranceMessages.create', 'sv', 'Skapa meddelande', '<h1>Skapa meddelande</h1>', 1, 'mango');
insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('_communication.entranceMessages.edit', 'f_communication.entranceMessages', true, 4);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_communication.entranceMessages.edit', 'sv', 'Redigera meddelande', '<h1>Redigera meddelande</h1>', 1, 'mango');


-- Tools
insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('f_tools', null, true, 7);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('f_tools', 'sv', 'Verktyg', null, 1, 'mango');
insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('_tools.overview', 'f_tools', true, 1);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_tools.overview', 'sv', '�versikt', '<h1>�versikt verktyg</h1>', 1, 'mango');
insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('_tools.admin', 'f_tools', true, 2);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_tools.admin', 'sv', 'Administrationen', '<h1>Administrationen</h1>', 1, 'mango');
insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('_tools.skill', 'f_tools', true, 3);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_tools.skill', 'sv', 'Kompetenshanteringen', '<h1>Kompetenshanteringen</h1>', 1, 'mango');
insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('_tools.notepad', 'f_tools', true, 4);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_tools.notepad', 'sv', 'Anteckningsblocket', '<h1>Anteckningsblocket</h1>', 1, 'mango');
insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('_tools.calendar', 'f_tools', true, 5);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_tools.calendar', 'sv', 'Kalender', '<h1>Kalender</h1>', 1, 'mango');
insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('_tools.calculator', 'f_tools', true, 6);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_tools.calculator', 'sv', 'Minir�knare', '<h1>Minir�knare</h1>', 1, 'mango');


-- Support
insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('f_support', null, true, 8);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('f_support', 'sv', 'Support', null, 1, 'mango');
insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('_support.overview', 'f_support', true, 1);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_support.overview', 'sv', '�versikt', '<h1>�versikt support</h1>', 1, 'mango');
insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('_support.computer.check', 'f_support', true, 2);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_support.computer.check', 'sv', 'Datorkontroll', '<h1>Datorkontroll</h1>', 1, 'mango');
insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('_support.faq', 'f_support', true, 3);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_support.faq', 'sv', 'Vanliga fr�gor', '<h1>Vanliga fr�gor</h1>', 1, 'mango');
insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('_support.contact', 'f_support', true, 4);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_support.contact', 'sv', 'Kontakt', '<h1>Kontakt</h1>', 1, 'mango');
insert into page (page_id, parent_page_id, is_folder, seq_nr)
	values ('_support.about', 'f_support', true, 5);
insert into content (page_id, lang, title, content, version, saved_by)
	values ('_support.about', 'sv', 'Om PING PONG', '<h1>Om PING PONG</h1>', 1, 'mango');



UPDATE db_version SET version = 2;
----------------------------------------
-- END BLOCK: 3
----------------------------------------


----------------------------------------
-- BEGIN BLOCK: 4
----------------------------------------
alter table page add column under_development boolean;

UPDATE db_version SET version = 4;
----------------------------------------
-- END BLOCK: 4
----------------------------------------


----------------------------------------
-- BEGIN BLOCK: 5
----------------------------------------
create table admin (userid text not null);

UPDATE db_version SET version = 5;
----------------------------------------
-- END BLOCK: 5
----------------------------------------


----------------------------------------
-- BEGIN BLOCK: 6
----------------------------------------
alter table page add column is_manual boolean;

UPDATE db_version SET version = 6;
----------------------------------------
-- END BLOCK: 6
----------------------------------------



----------------------------------------
-- BEGIN BLOCK: 7
----------------------------------------
alter table page add column admin_topic boolean;

UPDATE db_version SET version = 7;
----------------------------------------
-- END BLOCK: 7
----------------------------------------



----------------------------------------
-- BEGIN BLOCK: 8
----------------------------------------
alter table page add column giver_prop text;

UPDATE db_version SET version = 8;
----------------------------------------
-- END BLOCK: 8
----------------------------------------


----------------------------------------
-- BEGIN BLOCK: 9
----------------------------------------
begin;
create table tags (
	tag_id serial primary key
);

create table tag_names (
	tag_id integer,
	lang text,
	name text,
	foreign key (tag_id) references tags on delete cascade on update cascade,
	primary key (tag_id, lang)
);

create table page_tags (
	page_id text references page on delete cascade on update cascade,
	tag_id integer references tags on delete cascade on update cascade,
	primary key (page_id, tag_id)
);

UPDATE db_version SET version = 9;
commit;
----------------------------------------
-- END BLOCK: 9
----------------------------------------



----------------------------------------
-- BEGIN BLOCK: 10
----------------------------------------
ALTER TABLE content ADD COLUMN published boolean;
update  content set published='true';

UPDATE db_version SET version = 10;
----------------------------------------
-- END BLOCK: 10
----------------------------------------



----------------------------------------
-- BEGIN BLOCK: 11
----------------------------------------
alter table content add column content_id serial primary key;
alter table page add column student_topic boolean not null default false;
alter table page alter column teacher_topic set not null;

update page set teacher_topic=false where admin_topic is null;
alter table page alter column teacher_topic set not null;

update page set admin_topic=false where admin_topic is null; 
alter table page alter column admin_topic set default false;
alter table page alter column admin_topic set not null;
UPDATE db_version SET version = 11;
----------------------------------------
-- END BLOCK: 11
----------------------------------------



----------------------------------------
-- BEGIN BLOCK: template
----------------------------------------
-- UPDATE db_version SET version = template;
----------------------------------------
-- END BLOCK: template
----------------------------------------
