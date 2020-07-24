# -*- coding: utf-8 -*-

def interface():
    from .signal_handler import jack_model_post_save

import six,datetime,json,decimal,uuid
from functools import reduce

from django.utils import six
from django.utils.timezone import is_aware
from django.db.models.base import Model
from django.db.models.query import QuerySet
from django.forms.models import model_to_dict
from django.core.serializers import get_serializer
from django.utils.duration import duration_iso_string
from django.utils.safestring import mark_safe
from django.utils.functional import Promise
from django.forms import Widget

from django.http import HttpResponse,HttpRequest


class JSONEncoder(json.JSONEncoder):
    """
    JSONEncoder subclass that knows how to encode date/time, decimal types and UUIDs.
    """
    def __init__(self, *args, **kwargs):
        super(JSONEncoder, self).__init__(*args, **kwargs)

    def default(self, o):
        # See "Date Time String Format" in the ECMA-262 specification.
        if isinstance(o, datetime.datetime):
            r = o.isoformat()
            if o.microsecond:
                r = r[:23] + r[26:]
            if r.endswith('+00:00'):
                r = r[:-6] + 'Z'
            return r
        elif isinstance(o, datetime.date):
            return o.isoformat()
        elif isinstance(o, datetime.time):
            if is_aware(o):
                raise ValueError("JSON can't represent timezone-aware times.")
            r = o.isoformat()
            if o.microsecond:
                r = r[:12]
            return r
        elif isinstance(o, datetime.timedelta):
            return duration_iso_string(o)
        elif isinstance(o, decimal.Decimal):
            return str(o)
        elif isinstance(o, uuid.UUID):
            return str(o)
        elif isinstance(o, Model):
            return model_to_dict(o)
        elif isinstance(o, QuerySet):
            json_serializer = get_serializer('json')()
            json_serializer.serialize(o)
            return json_serializer.getvalue()
        elif isinstance(o, ResultsPage):
            context = {
                'total': o.total,  # 总记录数
                'pagecount': o.pagecount,  # 总页数
                'pagelen': o.pagelen,  # 当前页总记录数
                'pagenum': o.pagenum,  # 当前页号
                'offset': o.offset,  # 当前页首 记录号
                'is_last_page': o.is_last_page(),  # 是否末页
                'has_exact_length'
                'results': [whoosh_hit_to_dict(i) for i in o],
            }
            return context
        elif isinstance(o, Promise):
            return six.text_type(o)
        else:
            return super(JSONEncoder, self).default(o)


class JsonResponse(HttpResponse):
    """
    An HTTP response class that consumes data to be serialized to JSON.
    """

    def __init__(self, data, encoder=JSONEncoder, safe=True,
                 json_dumps_params=None, **kwargs):
        if safe and not isinstance(data, dict):
            raise TypeError(
                'In order to allow non-dict objects to be serialized set the '
                'safe parameter to False.'
            )
        if json_dumps_params is None:
            json_dumps_params = {}
        kwargs.setdefault('content_type', 'application/json')
        data = json.dumps(data, cls=encoder, **json_dumps_params)
        super(JsonResponse, self).__init__(content=data, **kwargs)


class JsonEditorWidget(Widget):
    """
    在 django  admin 后台中使用  jsoneditor 处理 JSONField

    TODO：有待改进, 这里使用 % 格式化，使用 format 会抛出 KeyError 异常
    """

    html_template = """
    <div id='%(name)s_editor_holder' style='padding-left:170px'></div>
    <textarea hidden readonly class="vLargeTextField" cols="40" id="id_%(name)s" name="%(name)s" rows="20">%(value)s</textarea>

    <script type="text/javascript">
        var element = document.getElementById('%(name)s_editor_holder');
        var json_value = %(value)s;

        var %(name)s_editor = new JSONEditor(element, {
            onChange: function() {
                var textarea = document.getElementById('id_%(name)s');
                var json_changed = JSON.stringify(%(name)s_editor.get()['Object']);
                textarea.value = json_changed;
            }
        });

        %(name)s_editor.set({"Object": json_value})
        %(name)s_editor.expandAll()
    </script>
    """

    def __init__(self, attrs=None):
        super(JsonEditorWidget, self).__init__(attrs)

    def render(self, name, value, attrs=None):
        if isinstance(value, str):
            value = json.loads(value)

        result = self.html_template % {'name': name, 'value': json.dumps(value), }
        return mark_safe(result)


SUBS=(('src="//', 'src="http://'), ("src='//", "src='http://"), ('href="//', 'href="http://'), ("href='//", "href='http://"))
OPTS ={'page-size': 'A4', 'encoding': 'UTF-8'}
