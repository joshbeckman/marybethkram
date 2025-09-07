---
title: Marybeth Kram
layout: home
profile_picture:
  src: /assets/img/marybeth.jpeg
  alt: Profile photo of Marybeth
---
{{ site.description }}

## Upcoming Shows

Shows are listed about a month in advance.

Click any event for details.

<div id='calendar'></div>
<script id="calendar-js" src='/assets/js/vendor/fullcalendar.index.global.min.js'></script>
<script src="/assets/js/vendor/ical.min.js"></script>
<script src="/assets/js/vendor/fullcalendar.icalendar.global.min.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function() {
  var iCalURL = 'https://p57-caldav.icloud.com/published/2/MTM1OTE1NDM4NDEzNTkxNaX01E2vsgBXvJdLR2tCYdnBQr270iUB0EOJMVZDENhd7yA7Y6hr9WU4O5INm8o3z6VsjHUBf9vvzDKWqvIJzhc';
  var calendarEl = document.getElementById('calendar');
  var calendar = new FullCalendar.Calendar(calendarEl, {
    initialView: 'listMonth',
    events: {
      url: `https://corsproxy.io/?url=${encodeURIComponent(iCalURL)}`,
      format: 'ics',
    },
    eventClick: function(info) {
      info.jsEvent.preventDefault();
      if (info.event.url) {
        window.open(info.event.url, '_blank');
        return;
      }
      var details = info.event.title;
      if (info.event.extendedProps.location) {
        details += '\n\nLocation: ' + info.event.extendedProps.location;
      }
      if (info.event.extendedProps.description) {
        details += '\n\nDescription: ' + info.event.extendedProps.description;
      }
      alert(details);
    },
    eventDidMount: function(info) {
      if (info.event.extendedProps.location) {
        var locationEl = document.createElement('div');
        locationEl.className = 'fc-event-location';
        locationEl.style.fontSize = '0.9em';
        locationEl.style.opacity = '0.8';
        locationEl.innerHTML = '📍 ' + info.event.extendedProps.location;
        info.el.querySelector('.fc-list-event-title').appendChild(locationEl);
      }
      if (info.event.extendedProps.description) {
        var descEl = document.createElement('div');
        descEl.className = 'fc-event-description';
        descEl.style.fontSize = '0.85em';
        descEl.style.fontStyle = 'italic';
        descEl.style.marginTop = '4px';
        descEl.innerHTML = info.event.extendedProps.description;
        info.el.querySelector('.fc-list-event-title').appendChild(descEl);
      }
    },
  });
  calendar.render();
});
</script>
