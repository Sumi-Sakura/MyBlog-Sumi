{% if theme.gitment.enable %}
    <div id="comments">
        {% set owner = theme.gitment.githubID %}
        {% set repo = theme.gitment.repo %}
        {% set cid = theme.gitment.ClientID %}
        {% set cs = theme.gitment.ClientSecret %}
        <script type="text/javascript" src="{{ url_for(theme.js) }}/src/cdn/gitment.browser.js?v={{ theme.version }}"></script>
        {% if not theme.gitment.lazy %}
            <script type="text/javascript">
                var gitment = new Gitment({
                    id: window.location.pathname, 
                    owner: '{{owner}}',
                    repo: '{{repo}}',
                    oauth: {
                        client_id: '{{cid}}',
                        client_secret: '{{cs}}',
                    }});
                gitment.render('gitment-container');
            </script>
        {% else %}
            <script type="text/javascript">
                function ShowGitment(){
                    document.getElementById("gitment-display-button").style.display = "none";
                    document.getElementById("gitment-container").style.display = "block";
                    var gitment = new Gitment({
                        id: window.location.pathname 
                        owner: '{{owner}}',
                        repo: '{{repo}}',
                        oauth: {
                            client_id: '{{cid}}',
                            client_secret: '{{cs}}',
                        }});
                    gitment.render('gitment-container');
                }
            </script>
        {% endif %}
    </div>
{% endif %}