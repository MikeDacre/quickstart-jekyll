---
layout: page
title: Info
permalink: /info/
excerpt: "A test of using data with liquid."
person: john
---

{% for person in site.data.test.people %}
  {% if person[0] == page.person %}
  Hi {{ person[1].name | capitalize }}, nice {% for thing in person[1].stuff %}{% if forloop.first %}{{ thing }}{% elsif forloop.last %} and {{ thing }}{% else %}, {{ thing }}{% endif %}{% endfor %}
  {% else %}
  Unknown person
  {% endif %}
{% endfor %}

{% for place in site.data.test.places %}
  Would you like to visit {{ place }}?
{% endfor %}
