CREATE INDEX ON :Member(id);

CREATE INDEX ON :Event(id);
CREATE INDEX ON :Event(time);
CREATE INDEX ON :Event(location);

CREATE INDEX ON :Group(id);
CREATE INDEX ON :Group(location);

CREATE INDEX ON :Venue(id);
CREATE INDEX ON :RSVP(id);
CREATE INDEX ON :Topic(urlkey);
CREATE INDEX ON :Country(code);
