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

{% assign events = site.data.events %}
{% if events and events.size > 0 %}
<ul class="show-list">
{% for event in events %}
  {% assign start = event.start | date: "%s" | plus: 0 %}
  {% assign date_label = event.start | date: "%a %b %-d, %Y" %}
  {% assign time_label = event.start | date: "%-l:%M %p" %}
  <li class="show">
    <div class="show-when">
      <div class="show-date">{{ date_label }}</div>
      {% unless event.all_day %}<div class="show-time">{{ time_label }}</div>{% endunless %}
    </div>
    <div class="show-what">
      {% if event.url and event.url != "" %}
        <a class="show-title" href="{{ event.url }}" target="_blank" rel="noopener">{{ event.title }}</a>
      {% else %}
        <span class="show-title">{{ event.title }}</span>
      {% endif %}
      {% if event.location and event.location != "" %}
        <div class="show-location">📍 {{ event.location | newline_to_br }}</div>
      {% endif %}
      {% if event.description and event.description != "" %}
        <div class="show-description">{{ event.description | newline_to_br }}</div>
      {% endif %}
    </div>
  </li>
{% endfor %}
</ul>
{% else %}
<p><em>No upcoming shows are on the calendar right now — check back soon.</em></p>
{% endif %}
