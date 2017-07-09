<div class="copyright" >
  {% set current = date(Date.now(), "YYYY") %}
  &copy; {% if theme.since and theme.since != current %} {{ theme.since }} - {% endif %}
  <span itemprop="copyrightYear">{{ current }}</span>
  <span class="with-love">
    <i class="fa fa-{{ theme.authoricon }}"></i>
  </span>
  <span class="author" itemprop="copyrightHolder">{{ config.author }}</span>
</div>

{% if theme.copyright %}
<div>
  盡了力還是有遺憾，就表示那是愛吧
</div>
{% endif %}

{% if theme.busuanzi_count.enable %}
<div class="busuanzi-count">
  <script type="text/javascript" src="{{ url_for(theme.js) }}/src/cdn/busuanzi.pure.mini.js?v={{ theme.version }}"></script>
  {% if theme.busuanzi_count.site_uv %}
    <span class="site-uv">
      {{ theme.busuanzi_count.site_uv_header }}
      <span class="busuanzi-value" id="busuanzi_value_site_uv"></span>
      {{ theme.busuanzi_count.site_uv_footer }}
    </span>
  {% endif %}

  {% if theme.busuanzi_count.site_pv %}
    <span class="site-pv">
      {{ theme.busuanzi_count.site_pv_header }}
      <span class="busuanzi-value" id="busuanzi_value_site_pv"></span>
      {{ theme.busuanzi_count.site_pv_footer }}
    </span>
  {% endif %}

  <div class="theme-info">
    <i class="fa fa-pencil"></i>
    <span class="post-count">所有文章共 {{ totalcount(site) }} 字</span>
  </div>
</div>
{% endif %}

