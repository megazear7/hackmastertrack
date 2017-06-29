(function(){
    window.HackTrack = {};

    HackTrack.open = function($card, preventPushState) {
        var data = $card.data();
        var category = data.category;
        var title = data.title;

        if (! preventPushState) {
            history.pushState({action: "details", category: category, id: data.id}, null, '/new#details/'+category+"/"+title);
        }

        $(".details-title").text(data.title.titleize());

        if (data.categoryReadable) {
            $(".details-category").text(data.categoryReadable);
        }

        $(".default-cell, .search-cell").slideUp({duration: 200}).promise().done(function() {
            $(".details-cell").slideDown(200);
        });
    };

    HackTrack.close = function() {
        $(".details-cell, .search-cell").slideUp({duration: 200}).promise().done(function() {
            $(".default-cell").slideDown(200);
        });
    };

    HackTrack.search = function(terms, preventPushState) {
        if (! preventPushState) {
            history.pushState({action: "search", terms: terms}, null, '/new#search/'+terms);
        }

        $(".search-cell").addClass("search-cell-remove").slideUp({duration: 200}).promise().done(function() {
            $(".search-cell-remove").remove();
        });


        HackSolr.search(terms, { owners: ["2"], groups: ["everyone"] }, function(results) {
            $.each(results, function() {
                var $searchCell = $(".search-cell-template").clone();
                $searchCell.removeClass("search-cell-template");
                $searchCell.addClass("search-cell");
                $searchCell.find(".mdl-card").attr("data-id", this.path);
                $searchCell.find(".mdl-card").attr("data-title", this.title);
                $searchCell.find(".mdl-card").attr("data-category", this.category1);
                $searchCell.find(".mdl-card").attr("data-category-readable", this.category1.titleize());
                $searchCell.find(".search-title").text(this.title);
                $searchCell.find(".action1").text("Purchase");
                $searchCell.find(".action2").text("View");
                $searchCell.find(".action2").addClass("card-opener");
                $searchCell.find(".search-support-text").text(this.category1);
                $searchCell.insertAfter(".search-cell-template");

                $(".card-opener").off("click").click(function() {
                    HackTrack.open($(this.closest(".mdl-card")));
                });
            });

            $(".default-cell, .details-cell").slideUp({duration: 200}).promise().done(function() {
                $(".search-cell").slideDown(200);
            });
        });
    };

    HackTrack.back = function() {
        // This 10ms is needed otherwise the history.state info is outdated.
        setTimeout(function() {
            var state = history.state;

            if (!state || state && ! state.action) {
                HackTrack.close();
            } else if (state.action === "details") {
                HackTrack.open($("[data-id='"+state.id+"']"), true);
            } else if (state.action === "search") {
                HackTrack.search($(".hack-search").find("input").val(), true);
            }
        }, 10);
    };

    HackTrack.get = function(category, idOrCallback, optionalCallack) {
        if (typeof idOrCallback === "function") {
            var callback = idOrCallback;
            $.get(category+".json").done(function(data) {
                callback(data);
            });
        } else {
            var id = idOrCallback;
            var optionalCallack = optionalCallack;
        }
    };

    HackTrack.each = function(category, callback) {
        HackTrack.get(category, function(items) {
            $.each(items, function(index, item) {
                callback(item);
            });
        });
    };
})();

/*
$(document).ready(function() {
    history.pushState({}, null, '/new#');

    var $characters = $(".characters");
    HackTrack.each("characters", function(character) {
        var $character = $("<a class='mdl-navigation__link character' href='#"+character.id+"'></a>");
        $character.data(character);
        $character.text(character.name);
        $characters.prepend($character);

        $character.click(function() {
            $(".character-name").text(character.name);
            $(".character").removeClass("mdl-navigation__link--current");
            $character.addClass("mdl-navigation__link--current");
        });
    });

    $(".card-opener").off("click").click(function() {
        HackTrack.open($(this.closest(".mdl-card")));
    });

    $(".back").click(function() {
        history.back();
    });

    $(".hack-search").submit(function(e) {
        e.preventDefault();
        HackTrack.search($(this).find("input").val());
    });

    window.addEventListener('popstate', function() {
        HackTrack.back();
    });
});
*/

// Example, remove once we have a real component that uses all of these features
class Welcome extends React.Component {
  constructor(props) {
    super(props);
    this.state = {date: new Date()};
  }

  componentDidMount() {
    this.timerID = setInterval(
      () => this.tick(),
      1000
    );
  }

  componentWillUnmount() {
    clearInterval(this.timerID);
  }

  tick() {
    this.setState({
      date: new Date()
    });
  }

  render() {
    return <h1>Hello, {this.props.name} - {this.state.date.toLocaleTimeString()}</h1>;
  }
}

// Example, remove once we have a real component that uses all of these features
class Toggler extends React.Component {
    constructor(props) {
        super(props);
        this.state = { isToggleOn: true };

        this.handleClick = this.handleClick.bind(this);
    }

    handleClick() {
        this.setState((prevState) => ({
            isToggleOn: !prevState.isToggleOn
        }));
    }

    render() {
        return (
            <button onClick={this.handleClick}>
                {this.state.isToggleOn ? 'ON' : 'OFF'}
            </button>
        );
    }
}

class CardTitle extends React.Component {
    render() {
        return (
            <div className="mdl-card__title mdl-card--expand">
                <h2 className="mdl-card__title-text">Combat</h2>
            </div>
        );
    }
}

class CardText extends React.Component {
    render() {
        return (
            <div className="mdl-card__supporting-text">
                Your combat values and equiped weapon / armor sets.
            </div>
        );
    }
}

class CardActions extends React.Component {
    render() {
        return (
            <div className="mdl-card__actions mdl-card--border">
                <a className="card-opener mdl-button mdl-button--colored mdl-js-button mdl-js-ripple-effect">Open</a>
            </div>
        );
    }
}

class Card extends React.Component {
    constructor(props) {
        super(props);
    }

    render() {
        return (
            <div className="mdl-card mdl-shadow--2dp" title="combat" data-category-readable="Character Details" data-category="character_info" data-id="/character_info/combat">
                <CardTitle />
                <CardText />
                <CardActions />
            </div>
        );
    }
}

class Cell extends React.Component {
    constructor(props) {
        super(props);
    }

    cellClass(desktop, tablet, phone) {
        return "mdl-cell mdl-cell--"+desktop+"-col mdl-cell--"+tablet+"-col-tablet mdl-cell--"+phone+"-col-phone";
    }

    render() {
        return (
            <div className={this.cellClass(3,4,2) + " default-cell"}>
                <Card />
            </div>
        );
    }
}

class App extends React.Component {
  render() {
    return(
        <Cell />
    );
  }
}

$(document).ready(function() {
    var app = <App />;
    ReactDOM.render(app, document.getElementById('react-root'));
});

Array.prototype.remove = function() {
    var what, a = arguments, L = a.length, ax;
    while (L && this.length) {
        what = a[--L];
        while ((ax = this.indexOf(what)) !== -1) {
            this.splice(ax, 1);
        }
    }
    return this;
};

String.prototype.capitalize = function() {
    return this.charAt(0).toUpperCase() + this.slice(1);
}

String.prototype.titleize = function() {
    var string_array = this.split(' ');
    string_array = string_array.map(function(str) {
       return str.capitalize(); 
    });
    
    return string_array.join(' ');
}
