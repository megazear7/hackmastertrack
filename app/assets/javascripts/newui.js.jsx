function createHackComponent(hackEntity, forward) {
    if (hackEntity.category1 === "overview") {
        return hackComponent = (
            <Overview hackEntity={hackEntity}
                      key={hackEntity.path}
                      forward={forward} />);
    } else {
        return hackComponent = (
            <Unimplemented hackEntity={hackEntity}
                           key={hackEntity.path}
                           forward={forward} />);
    }
}

/* Section 1: Hack Components
 * These components are react components representing hackmastertrack entities. */

class Overview extends React.Component {
    constructor(props) {
        super(props);

        this.open = this.open.bind(this);
    }

    open() {
        // TODO Use hackapi.js (yet to be created) to interface with the rails
        // json API in order to obtain the character data
        var character = {
            name: "Slighter",
            race: "Human",
            character_class: "Fighter",
            strength: 16.75,
            dexterity: 14.12,
            constitution: 11.34,
            intelligence: 12.78,
            wisdom: 8.76,
            charisma: 6.89,
            looks: 7.89
        };

        this.props.forward([
            <Cell desktop="9" key="title">
                <span className="mdl-typography--display-1">
                    {this.props.hackEntity.title}
                </span>
            </Cell>,
            <Cell desktop="4" tablet="4" phone="2" key="1">
                <Card>
                    <CardText text={character.race + " " + character.character_class} />
                </Card>
            </Cell>,
            <Cell desktop="4" tablet="4" phone="2" key="2">
                <Card>
                    <CardText text={character.strength} />
                </Card>
            </Cell>]);
    }

    render() {
        return (
            <Cell desktop="3" tablet="4" phone="2">
                <Card>
                    <CardTitle text={this.props.hackEntity.title} />
                    <CardText text={this.props.hackEntity.description} />
                    <CardActions open={this.open} />
                </Card>
            </Cell>
        );
    }
}

/* This is a generic Hack Component that just displays the title, description
 * and category of the Hack Entity. This will be used if no other Hack Component
 * is found to match the Hack Entity. */
class Unimplemented extends React.Component {
    constructor(props) {
        super(props);

        this.open = this.open.bind(this);
    }

    open() {
        this.props.forward([
            <Cell desktop="9" key="title">
                <span className="mdl-typography--display-1">
                    {this.props.hackEntity.title}
                </span>
            </Cell>,
            <Cell desktop="3" key="description">
                <span className="mdl-typography--headline">
                    {this.props.hackEntity.category1}
                </span>
            </Cell>]);
    }

    render() {
        return (
            <Cell desktop="3" tablet="4" phone="2">
                <Card>
                    <CardTitle text={this.props.hackEntity.title} />
                    <CardText text={this.props.hackEntity.description} />
                    <CardActions open={this.open} />
                </Card>
            </Cell>
        );
    }
}

/* Section2: MDL Components
 * These components are React.Components representing MDL Componentes. */

class CardTitle extends React.Component {
    render() {
        return (
            <div className="mdl-card__title mdl-card--expand">
                <h2 className="mdl-card__title-text">{this.props.text}</h2>
            </div>
        );
    }
}

class CardText extends React.Component {
    render() {
        return (
            <div className="mdl-card__supporting-text">
                {this.props.text}
            </div>
        );
    }
}

class CardActions extends React.Component {
    render() {
        return (
            <div className="mdl-card__actions mdl-card--border">
                <a onClick={this.props.open} className="mdl-button mdl-button--colored">
                    Open
                </a>
            </div>
        );
    }
}

class BackButton extends React.Component {
    render() {
        return (
            <button className="mdl-button mdl-js-button mdl-button--icon back">
                <i className="material-icons" onClick={this.props.action}>arrow_back</i>
            </button>
        );
    }
}

class Cell extends React.Component {
    cellClass() {
        var cellClasses = ["mdl-cell"];

        if (this.props.desktop === 0) {
            cellClasses.push("mdl-cell--hide-desktop");
        } else {
            cellClasses.push("mdl-cell--"+this.props.desktop+"-col-desktop");
        }

        if (this.props.tablet === 0) {
            cellClasses.push("mdl-cell--hide-tablet");
        } else {
            cellClasses.push("mdl-cell--"+this.props.tablet+"-col-tablet");
        }

        if (this.props.phone === 0) {
            cellClasses.push("mdl-cell--hide-phone");
        } else {
            cellClasses.push("mdl-cell--"+this.props.phone+"-col-phone");
        }

        return cellClasses.join(" ");
    }

    render() {
        return (
            <div className={this.cellClass()}>
                {this.props.children}
            </div>
        );
    }
}

class Card extends React.Component {
    render() {
        return (
            <div className="mdl-card hack-full-card mdl-shadow--2dp">
                {this.props.children}
            </div>
        );
    }
}

class Search extends React.Component {
    constructor(props) {
        super(props);

        this.state = {terms: ''};

        this.handleChange = this.handleChange.bind(this);
        this.handleSubmit = this.handleSubmit.bind(this);
    }

    componentDidMount() {
        componentHandler.upgradeElement(this.textInput);
    }

    handleChange(e) {
        this.setState({terms: e.target.value});
    }

    handleSubmit(e) {
        e.preventDefault();
        var self = this;

        HackSolr.search(this.state.terms, { owners: ["2"], groups: ["everyone"] }, function(results) {
            var searchResultCards = [];

            console.log(results);

            $.each(results, function() {
                searchResultCards.push(createHackComponent(hackEntity, this.props.forward));
            });

            self.props.forward(searchResultCards);
        });
    }

    render() {
        return (
            <form onSubmit={this.handleSubmit}>
                <div className="mdl-textfield mdl-js-textfield" ref={(input) => { this.textInput = input; }}>
                    <input className="mdl-textfield__input" type="text" id="hack-search" onChange={this.handleChange} />
                    <label className="mdl-textfield__label" htmlFor="hack-search">Search for anything...</label>
                </div>
            </form>
        )
    }
}

class Grid extends React.Component {
    render() {
        return (
            <div className="mdl-grid">
                <Cell desktop="2" tablet="2" phone="0">
                    {this.props.showBackButton && <BackButton action={this.props.backward} />}
                </Cell>
                <Cell desktop="2" tablet="0" phone="0" />
                <Cell desktop="4" tablet="4" phone="4">
                    <Search forward={this.props.forward} />
                </Cell>
                <Cell desktop="4" tablet="2" phone="0" />
                {this.props.children}
            </div>
        );
    }
}

class Content extends React.Component {
    constructor(props) {
        super(props);

        this.backToStart = this.backToStart.bind(this);
        this.forward = this.forward.bind(this);
        this.backward = this.backward.bind(this);
        this.cells = this.cells.bind(this);

        this.state = { };

        this.state.startCards = this.props.startTiles.map((hackEntity) =>
            createHackComponent(hackEntity, this.forward)
        );

        this.state.history = [ ];
        this.state.history.push(this.state.startCards);
    }

    backToStart() {
        this.forward(this.state.startCards);
    }

    forward(cells) {
        if (this.state.history.length < 40) {
            this.state.history.push(cells);
            this.forceUpdate();
        } else {
            this.setState(function(prevState, props) {
                var newHistory = prevState.history.slice(prevState.history.length / 2);
                newHistory.push(cells);
                return { history: newHistory };
            });
        }
    }

    backward() {
        this.state.history.pop();
        this.forceUpdate();
    }

    cells() {
        return this.state.history[this.state.history.length-1]
    }

    render() {
        return(
            <main className="mdl-layout__content">
                <Grid forward={this.forward}
                      backward={this.backward}
                      showBackButton={this.state.history.length > 1}>
                    {this.cells()}
                </Grid>
            </main>
        );
    }
}

class IconLink extends React.Component {
    render() {
        return (
          <a className="mdl-navigation__link" href={this.props.href}>
            <i className="material-icons">{this.props.icon}</i>
            Character
          </a>
        );
    }
}

class Link extends React.Component {
    render() {
        return (
            <span className="mdl-layout__link">
                <a className="mdl-navigation__link" href={this.props.href}>{this.props.title}</a>
            </span>
        );
    }
}

class Drawer extends React.Component {
    render() {
      return (
        <div className="mdl-layout__drawer">
            <span className="mdl-layout__title">{this.props.title}</span>
            <nav className="mdl-navigation">
              <IconLink href="/characters/step1" icon="add" />
            </nav>
        </div>
      );
    }
}


class Header extends React.Component {
    constructor(props) {
        super(props);
        this.state = { };

        this.state.characterName = "Slighter";
    }

    render() {
        return (
          <header className="mdl-layout__header">
            <div className="mdl-layout__header-row">
              <span className="mdl-layout__title">
                {this.state.characterName}
              </span>
              <div className="mdl-layout-spacer"></div>
              <Link href="/" title="Classic Version" />
            </div>
          </header>
        )
    }
}

class Layout extends React.Component {
    render() {
        return (
            <div className="mdl-layout mdl-js-layout mdl-layout--fixed-drawer mdl-layout--fixed-header mdl-color-text--grey-600 main-layout">
                <Header />
                <Drawer title={this.props.title} />
                <Content startTiles={this.props.startTiles} />
            </div>
        );
    }
}

$(document).ready(function() {
    var startTiles = [
        {
            name: "overview",
            category1: "overview",
            title: "Overview",
            description: "Your characters race, class, ability scores, money, health and experience.",
        },
        {
            name: "combat",
            category1: "combat",
            title: "Combat",
            description: "Your combat values and equiped weapon / armor sets.",
        },
        {
            name: "spells",
            category1: "spells",
            title: "Spells",
            description: "Your spells. Lorem ipsum...",
        },
        {
            name: "equipment",
            category1: "equipment",
            title: "Equipment",
            description: "Your characters weapons, armor and inventory.",
        },
        {
            name: "proficiencies",
            category1: "proficiencies",
            title: "Proficiencies",
            description: "Lorem ipsum lor so todo...",
        },
        {
            name: "specializations",
            category1: "specializations",
            title: "Specializations",
            description: "Lorem ipsum lor so todo...",
        },
        {
            name: "talents",
            category1: "talents",
            title: "Talents",
            description: "Lorem ipsum lor so todo...",
        },
        {
            name: "skills",
            category1: "skills",
            title: "Skills",
            description: "Your talents, proficiencies, skills, and .",
        }
    ];

    var layout = <Layout startTiles={startTiles} title="Hacktrack" />;
    ReactDOM.render(layout, document.getElementById('react-root'));
});
