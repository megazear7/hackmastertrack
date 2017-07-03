function cellClass(desktop, tablet, phone) {
    var desktopClass,
        tabletClass,
        phoneClass;

    if (typeof desktop === undefined) {
        desktopClass = "";
    } else if (desktop === 0) {
        desktopClass = "mdl-cell--hide-desktop";
    } else {
        desktopClass = "mdl-cell--"+desktop+"-col-desktop";
    }

    if (typeof tablet === undefined) {
        tabletClass = "";
    } else if (tablet === 0) {
        tabletClass = "mdl-cell--hide-tablet";
    } else {
        tabletClass = "mdl-cell--"+tablet+"-col-tablet";
    }

    if (typeof phone === undefined) {
        phoneClass = "";
    } else if (phone === 0) {
        phoneClass = "mdl-cell--hide-phone";
    } else {
        phoneClass = "mdl-cell--"+phone+"-col-phone";
    }

    return "mdl-cell "+desktopClass+" "+tabletClass+" "+phoneClass;
}

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

class Card extends React.Component {
    constructor(props) {
        super(props);

        this.open = this.open.bind(this);
    }

    open() {
        // TODO manage this detailsGrid variable in the state so that we can destroy it when needed.
        var detailsGrid = <DetailsGrid tile={this.props.tile}
                                       showCards={this.props.showCards}
                                       closeDetailsGrid={this.props.closeDetailsGrid}
                                       openDetailsGrid={this.props.openDetailsGrid} />;

        this.props.openDetailsGrid(detailsGrid);
    }

    render() {
        return (
            <div className={cellClass(3,4,2) + "mdl-card mdl-shadow--2dp"}>
                <CardTitle text={this.props.tile.title} />
                <CardText text={this.props.tile.description}/>
                <CardActions open={this.open} />
            </div>
        );
    }
}

class Search extends React.Component {
    constructor(props) {
        super(props);

        this.search = this.search.bind(this);
    }

    componentDidMount() {
        componentHandler.upgradeElement(this.textInput);
    }

    search(e) {
        e.preventDefault();
        console.log("Doing Search");

        var exampleSearchResults = [
            {
                name: "sword",
                title: "Sword",
                description: "An awesome weapon."
            },
            {
                name: "fireball",
                title: "Fireball",
                description: "A powerful spell."
            },
            {
                name: "longsword-proficiency",
                title: "Longsword Proficiency",
                description: "Learn the longword"
            },
            {
                name: "axe",
                title: "Axe",
                description: "Weapon of greatness"
            }
        ];

        var random1 = parseInt(Math.floor(Math.random() * 4));
        var random2 = parseInt(Math.floor(Math.random() * 4));

        var searchResultCards = []
        searchResultCards.push(<Card tile={exampleSearchResults[random1]}
              key={exampleSearchResults[random1].name}
              showCards={this.props.showCards}
              closeDetailsGrid={this.props.closeDetailsGrid}
              openDetailsGrid={this.props.openDetailsGrid} />);
        searchResultCards.push(<Card tile={exampleSearchResults[random2]}
              key={exampleSearchResults[random2].name}
              showCards={this.props.showCards}
              closeDetailsGrid={this.props.closeDetailsGrid}
              openDetailsGrid={this.props.openDetailsGrid} />);

        this.props.showCards(searchResultCards);
    }

    render() {
        return (
            <form onSubmit={this.search}>
                <div className="mdl-textfield mdl-js-textfield" ref={(input) => { this.textInput = input; }}>
                    <input className="mdl-textfield__input" type="text" id="hack-search" />
                    <label className="mdl-textfield__label" htmlFor="hack-search">Search for anything...</label>
                </div>
            </form>
        )
    }
}

class DetailsGrid extends React.Component {
    render() {
        return (
            <div className="mdl-grid">
                <div className={cellClass(2,2,0)}>
                    <BackButton action={this.props.closeDetailsGrid} />
                </div>
                <div className={cellClass(2,0,0)}></div>
                <div className={cellClass(4,4,4)}>
                    <Search showCards={this.props.showCards}
                            closeDetailsGrid={this.props.closeDetailsGrid}
                            openDetailsGrid={this.props.openDetailsGrid} />
                </div>
                <div className={cellClass(4,2,0)}></div>
                <div className={cellClass(6)+" mdl-typography--display-1"}>
                    {this.props.tile.title}
                </div>
                <div className={cellClass(6)+" mdl-typography--headline"}>
                    {this.props.tile.description}
                </div>
            </div>
        );
    }
}

class HomeGrid extends React.Component {
    render() {
        return (
            <div className="mdl-grid">
                <div className={cellClass(4,0,0)}></div>
                <div className={cellClass(4,4,4)}>
                    <Search showCards={this.props.showCards}
                            closeDetailsGrid={this.props.closeDetailsGrid}
                            openDetailsGrid={this.props.openDetailsGrid} />
                </div>
                <div className={cellClass(4,0,0)}></div>
                {this.props.cells}
            </div>
        );
    }
}

class Content extends React.Component {
    constructor(props) {
        super(props);
        this.state = { };

        this.state.detailsOpen = false;

        this.state.startCards = this.props.startTiles.map((tile) =>
            <Card tile={tile}
                  key={tile.name}
                  showCards={this.showCards}
                  closeDetailsGrid={this.closeDetailsGrid}
                  openDetailsGrid={this.openDetailsGrid} />
        );

        this.state.cells = this.state.startCards;

        this.openDetailsGrid = this.openDetailsGrid.bind(this);
        this.closeDetailsGrid = this.closeDetailsGrid.bind(this);
        this.backToStart = this.backToStart.bind(this);
        this.showCards = this.showCards.bind(this);
    }

    backToStart() {
        this.setState({
            cells: this.state.startCards
        });
    }

    showCards(cells) {
        this.setState({
            cells: cells
        });
    }

    openDetailsGrid(detailsGrid) {
        this.setState({
            detailsGrid: detailsGrid,
            detailsOpen: true
        });
    }

    closeDetailsGrid() {
        this.setState({
            detailsOpen: false
        });
    }

    render() {
        var grid;

        if (this.state.detailsOpen) {
            grid = this.state.detailsGrid;
        } else {
            grid = <HomeGrid cells={this.state.cells}
                             showCards={this.showCards}
                             openDetailsGrid={this.openDetailsGrid}
                             closeDetailsGrid={this.closeDetailsGrid} />;
        }

        return(
            <main className="mdl-layout__content">
                {grid}
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
            title: "Overview",
            description: "Your characters race, class, ability scores, money, health and experience.",
        },
        {
            name: "combat",
            title: "Combat",
            description: "Your combat values and equiped weapon / armor sets.",
        },
        {
            name: "spells",
            title: "Spells",
            description: "Your spells. Lorem ipsum...",
        },
        {
            name: "equipment",
            title: "Equipment",
            description: "Your characters weapons, armor and inventory.",
        },
        {
            name: "proficiencies",
            title: "Proficiencies",
            description: "Lorem ipsum lor so todo...",
        },
        {
            name: "specializations",
            title: "Specializations",
            description: "Lorem ipsum lor so todo...",
        },
        {
            name: "talents",
            title: "Talents",
            description: "Lorem ipsum lor so todo...",
        },
        {
            name: "skills",
            title: "Skills",
            description: "Your talents, proficiencies, skills, and .",
        }
    ];

    var layout = <Layout startTiles={startTiles} title="Hacktrack" />;
    ReactDOM.render(layout, document.getElementById('react-root'));
});
