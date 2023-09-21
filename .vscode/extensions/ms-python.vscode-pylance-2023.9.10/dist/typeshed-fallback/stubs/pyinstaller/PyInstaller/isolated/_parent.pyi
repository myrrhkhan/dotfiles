from collections.abc import Callable
from types import TracebackType
from typing import TypeVar
from typing_extensions import ParamSpec, Self

_AC = TypeVar("_AC", bound=Callable[..., object])
_R = TypeVar("_R")
_P = ParamSpec("_P")

class Python:
    def __init__(self, strict_mode: bool | None = None) -> None: ...
    def __enter__(self) -> Self: ...
    def __exit__(
        self, exc_type: type[BaseException] | None, exc_val: BaseException | None, exc_tb: TracebackType | None
    ) -> None: ...
    def call(self, function: Callable[_P, _R], *args: _P.args, **kwargs: _P.kwargs) -> _R: ...

def call(function: Callable[_P, _R], *args: _P.args, **kwargs: _P.kwargs) -> _R: ...
def decorate(function: _AC) -> _AC: ...
